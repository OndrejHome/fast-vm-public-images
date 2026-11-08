#!/bin/bash
## test if guestfish command is present
which guestfish 2>&1 > /dev/null
if [ "$?" != 0 ]; then
	echo "[!!!] Command 'guestfish' not found (Install it!). Making changes to VM FAILED."
	exit 1
fi
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
# detect the slot where network card is as system uses hardware-based names for network interfaces
net_card_slot=$(virsh --connect qemu:///system dumpxml $VM_NAME|xmllint --xpath "//interface[.//source[@network='$LIBVIRT_NETWORK']]/address/@slot" - 2>/dev/null|cut -d\" -f 2|head -1|cut -dx -f 2)
net_card=$(($net_card_slot+0))
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')
## timezone of hypervisor
timezone=$(readlink /etc/localtime | sed 's/^.*zoneinfo\/\(.*\)$/\1/')

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/os16vg/root_lv <<EOF
# change the hostname of machine
sh 'echo "$VM_HOSTNAME" > /etc/hostname'
# change timezone of machine to match hypervisor
sh 'rm -f /etc/localtime'
sh 'ln -s /usr/share/zoneinfo/$timezone /etc/localtime'
# enable root password login to SSH 
sh 'echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/61-enable-root-login.conf'
# disable default sshd PerSourcePenalties to allow rapid ssh-keyscan
sh 'echo "PerSourcePenalties no" > /etc/ssh/sshd_config.d/60-disable-PerSourcePenalties.conf'
# adjust network interface name in NetworkManager configuration
sh 'sed -i "s/interface-name=.*/interface-name=ens${net_card}/" /etc/NetworkManager/system-connections/*.nmconnection'
# remove quiet boot option
sh 'sed -i "s/quiet//" /boot/grub2/grub.cfg'
sh 'sed -i "s/quiet//" /etc/default/grub'
EOF
