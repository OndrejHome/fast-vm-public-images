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

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/c7vg/root_lv -m /dev/sda2:/boot -m /dev/sda1:/boot/efi --selinux <<EOF
sh 'sed -i "s/ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-eth0'
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/sysconfig/network-scripts/ifcfg-eth0
sh 'sed -i "s/terminal_output console/serial --unit=0 --speed=115200 --word=8 --parity=no\nterminal_input serial\nterminal_output serial/; s/rhgb quiet/console=ttyS0,115200n8/" /boot/efi/EFI/centos/grub.cfg'
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /boot/efi/EFI/centos/grub.cfg
sh 'sed -i "s/GRUB_TERMINAL_OUTPUT=\"console\"/GRUB_TERMINAL=\"serial\"\nGRUB_SERIAL_COMMAND=\"serial --speed=115200 --unit=0 --word=8 --parity=no\"/; s/rhgb quiet/console=ttyS0,115200n8/" /etc/default/grub'
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/default/grub
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/hostname
EOF
