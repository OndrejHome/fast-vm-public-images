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

# detect the slot where network card is as system uses hardware-based names for network interfaces
net_card_slot=$(virsh --connect qemu:///system dumpxml $VM_NAME|xmllint --xpath "//interface[.//source[@network='$LIBVIRT_NETWORK']]/address/@slot" - 2>/dev/null|cut -d\" -f 2|head -1|cut -dx -f 2)
net_card=$(($net_card_slot+0))

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/debian10vg/root -m /dev/sda1:/boot <<EOF
sh 'sed -i "s/quiet/console=ttyS0,115200n8 /" /boot/grub/grub.cfg'
sh 'sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"console=ttyS0,115200n8\"/; s/GRUB_CMDLINE_LINUX_DEFAULT=\".*\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub'
sh 'sed -i "s/inet loopback/inet loopback\nauto ens${net_card}\niface ens${net_card} inet dhcp/" /etc/network/interfaces'
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
sh 'sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config'
EOF
