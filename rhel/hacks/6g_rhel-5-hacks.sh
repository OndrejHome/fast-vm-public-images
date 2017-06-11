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

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/r5vg/root_lv -m /dev/sda1:/boot --selinux <<EOF
sh 'sed -i "s/HOSTNAME=.*$/HOSTNAME=$VM_HOSTNAME/" /etc/sysconfig/network'
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/sysconfig/network
EOF
