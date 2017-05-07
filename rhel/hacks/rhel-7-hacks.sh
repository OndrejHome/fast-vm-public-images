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

## determine if we have selinuxrelabel feature in guestfish
echo "[i] checking if selinuxrelabel is available"
guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" 2>/dev/null <<EOF
run
feature-available selinuxrelabel
EOF

if [ "$?" -eq 0 ]; then
read SELINUX_RELABEL <<EOF
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/sysconfig/network-scripts/ifcfg-eth0
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /boot/grub2/grub.cfg
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/default/grub
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/hostname
EOF
else
	echo "[w] selinuxrelabel is NOT available, '/.autorelabel' file will be created on VM to fix SELINUX contexts"
	SELINUX_RELABEL='touch /.autorelabel'
fi

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/r7vg/root_lv -m /dev/sda1:/boot --selinux <<EOF
sh 'sed -i "s/HWADDR=.*$/HWADDR=${VM_MAC}/; s/ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-eth0'
sh 'sed -i "s/terminal_output console/serial --unit=0 --speed=115200 --word=8 --parity=no\nterminal_input serial\nterminal_output serial/; s/root_lv/root_lv console=ttyS0,115200n8/; s/ rhgb//; s/ quiet//; s/crashkernel=auto/crashkernel=128M/" /boot/grub2/grub.cfg'
sh 'sed -i "s/GRUB_TERMINAL_OUTPUT=\"console\"/GRUB_TERMINAL=\"serial\"\nGRUB_SERIAL_COMMAND=\"serial --speed=115200 --unit=0 --word=8 --parity=no\"/; s/rhgb quiet/console=ttyS0,115200n8/; s/crashkernel=auto/crashkernel=128M/" /etc/default/grub'
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
$SELINUX_RELABEL
EOF
