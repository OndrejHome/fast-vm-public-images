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

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/r6vg/root_lv -m /dev/sda1:/boot --selinux <<EOF
sh 'sed -i "s/HWADDR=.*$/HWADDR=${VM_MAC}/; s/BOOTPROTO=.*//; s/ONBOOT=.*/ONBOOT=yes\nBOOTPROTO=dhcp/" /etc/sysconfig/network-scripts/ifcfg-eth0'
sh 'sed -i "s/default=0$/default=0 #edited\nserial --unit=0 --speed=115200 --word=8 --parity=no\nterminal --timeout=5 serial console/; s/^hiddenmenu/#hiddenmenu/; s/^splashimage/#splashimage/; s/root_lv/root_lv console=ttyS0,115200n8/; s/ rhgb//; s/ quiet//; s/crashkernel=auto/crashkernel=128M/" /boot/grub/grub.conf'
sh 'sed -i "s/HOSTNAME=.*$/HOSTNAME=$VM_HOSTNAME/" /etc/sysconfig/network'
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/sysconfig/network-scripts/ifcfg-eth0
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /boot/grub/grub.conf
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/sysconfig/network
EOF
