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
## timezone of hypervisor
timezone=$(readlink /etc/localtime | sed 's/^.*zoneinfo\/\(.*\)$/\1/')

# detect the slot where network card is as system uses hardware-based names for network interfaces
net_card_slot=$(virsh --connect qemu:///system dumpxml $VM_NAME|xmllint --xpath "//interface[.//source[@network='$LIBVIRT_NETWORK']]/address/@slot" - 2>/dev/null|cut -d\" -f 2|head -1|cut -dx -f 2)
net_card=$(($net_card_slot+0))

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/u1804vg/root_lv -m /dev/sda2:/boot <<EOF
# configure GRUB output to serial console
sh 'sed -i "s/terminal_output gfxterm/serial --unit=0 --speed=115200 --word=8 --parity=no\nterminal_input serial\nterminal_output serial/; s/root_lv /root_lv console=ttyS0,115200n8 /" /boot/grub/grub.cfg'
sh 'sed -i "s/GRUB_TERMINAL_OUTPUT=\"console\"/GRUB_TERMINAL=\"serial\"\nGRUB_SERIAL_COMMAND=\"serial --speed=115200 --unit=0 --word=8 --parity=no\"/; s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"console=ttyS0,115200n8\"/" /etc/default/grub'
# allow 'root' login for SSH
sh 'sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config'
# configure 'root' password
sh 'sed -i "s#^root.*#root:\\\$6\\\$KwxLHt4MoI68H4VX\\\$JXNoY6cD2xpcDafKWorxDpbQH46M0bS.8k.BvGqS6LHGg8BLTC2qwJi6HAEpcKQboCPiV7T6CWN9MchSi9bnR/:18385:0:99999:7:::#" /etc/shadow'
# enable DHCP on network card
sh 'echo "network: { ethernets: { ens${net_card}: { dhcp4: yes } }, version: 2}" > /etc/netplan/fast-vm-dhcp.yaml'
# set the hostname
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
# change timezone of machine to match hypervisor
sh 'rm -f /etc/localtime'
sh 'ln -s /usr/share/zoneinfo/$timezone /etc/localtime'
EOF
