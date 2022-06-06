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

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/os15vg/root_lv <<EOF
# change the hostname of machine
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
# change timezone of machine to match hypervisor
sh 'rm -f /etc/localtime'
sh 'ln -s /usr/share/zoneinfo/$timezone /etc/localtime'
# make first nic to be detected as eth0 (remove installation nic config)
sh 'rm -f /etc/udev/rules.d/70-persistent-net.rules'
# FIXME remove quiet boot option
sh 'sed -i "s/quiet//" /boot/grub2/grub.cfg'
sh 'sed -i "s/quiet//" /etc/default/grub'
EOF
