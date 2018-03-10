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

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/debian9vg/root -m /dev/sda1:/boot <<EOF
sh 'sed -i "s/quiet/console=ttyS0,115200n8 /" /boot/grub/grub.cfg'
sh 'sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"console=ttyS0,115200n8\"/; s/GRUB_CMDLINE_LINUX_DEFAULT=\".*\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub'
sh 'sed -i "s/inet loopback/inet loopback\nauto ens2\niface ens2 inet dhcp/" /etc/network/interfaces'
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
sh 'sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config'
EOF
