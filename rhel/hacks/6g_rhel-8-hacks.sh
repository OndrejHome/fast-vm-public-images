#!/bin/bash
## test if guestfish command is present
which guestfish 2>&1 > /dev/null
if [ "$?" != 0 ]; then
	echo "[!!!] Command 'guestfish' not found (Install it!). Making changes to VM FAILED."
	exit 1
fi
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')

if [ ! -f /var/lib/fast-vm/appliance/capability_xfs_el8 ] && [ ! -d /var/tmp/fedora29/appliance ]; then
        echo "[!!!] XFS_EL8 capable appliance or Fedora 29+ appliance is required for properrun"
        exit 1
fi
# compatibility: blindly try exporting path to fedora29 appliance
if [ -z "$LIBGUESTFS_PATH" ]; then export LIBGUESTFS_PATH=/var/tmp/fedora29/appliance; fi

# detect the slot where network card is as system uses hardware-based names for network interfaces
net_card_slot=$(virsh --connect qemu:///system dumpxml $VM_NAME|xmllint --xpath "//interface[.//source[@network='$LIBVIRT_NETWORK']]/address/@slot" - 2>/dev/null|cut -d\" -f 2|head -1|cut -dx -f 2)
net_card=$(($net_card_slot+0))
## timezone of hypervisor
timezone=$(readlink /etc/localtime | sed 's/^.*zoneinfo\/\(.*\)$/\1/')

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/r8vg/root_lv -m /dev/sda1:/boot --selinux <<EOF
# move the config from interface used during install to one assigned by libvirt as it may change (sometimes)
# if there was no change this will report error that can be safely ignored
-sh 'mv /etc/sysconfig/network-scripts/ifcfg-ens* /etc/sysconfig/network-scripts/ifcfg-ens${net_card}'
# enable ensX adapter on boot and rename interface if needed
-sh 'sed -i "s/ONBOOT=no/ONBOOT=yes/; s/NAME=.*/NAME=ens${net_card}/; s/DEVICE=.*/DEVICE=ens${net_card}/" /etc/sysconfig/network-scripts/ifcfg-ens${net_card}'
# change the hostname of machine
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
# change timezone of machine to match hypervisor
sh 'rm -f /etc/localtime'
sh 'ln -s /usr/share/zoneinfo/$timezone /etc/localtime'
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/localtime
-selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/sysconfig/network-scripts/ifcfg-ens${net_card}
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/hostname
EOF
