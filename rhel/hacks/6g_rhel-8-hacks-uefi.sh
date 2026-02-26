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

## timezone of hypervisor
timezone=$(readlink /etc/localtime | sed 's/^.*zoneinfo\/\(.*\)$/\1/')

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/r8vg/root_lv -m /dev/sda2:/boot -m /dev/sda1:/boot/efi --selinux <<EOF
# remove the network config for interface used during installation
-sh 'rm -f /etc/sysconfig/network-scripts/ifcfg-*'
# change the hostname of machine
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
# change timezone of machine to match hypervisor
sh 'rm -f /etc/localtime'
sh 'ln -s /usr/share/zoneinfo/$timezone /etc/localtime'
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/localtime
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/hostname
EOF
