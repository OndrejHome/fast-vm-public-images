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
## timezone of hypervisor
timezone=$(readlink /etc/localtime | sed 's/^.*zoneinfo\/\(.*\)$/\1/')

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/pve/root <<EOF
# disable graphical console to allow headless boot
sh 'sed -i "s/terminal_output gfxterm serial/terminal_output serial/" /boot/grub/grub.cfg'
sh 'sed -i "s/GRUB_TERMINAL_OUTPUT=\"gfxterm serial\"/GRUB_TERMINAL=\"serial\"/" /etc/default/grub.d/installer.cfg'
# disable quiet boot
sh 'sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub'
sh 'sed -i "s/quiet//" /boot/grub/grub.cfg'
# configure network to use dhcp instead of static ip
sh 'sed -i "/iface vmbr0/,+3d" /etc/network/interfaces'
sh 'sed -i "s/auto vmbr0/auto vmbr0\niface vmbr0 inet dhcp\n        bridge-ports ens${net_card}/" /etc/network/interfaces'
# change timezone of machine to match hypervisor
sh 'rm -f /etc/localtime'
sh 'ln -s /usr/share/zoneinfo/$timezone /etc/localtime'
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
EOF
