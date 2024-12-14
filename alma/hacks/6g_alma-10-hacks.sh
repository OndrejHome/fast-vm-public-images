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

if [ ! -f /var/lib/fast-vm/appliance/capability_xfs_el8 ] && [ ! -d /var/tmp/fedora29/appliance ]; then
        echo "[!!!] XFS_EL8 capable appliance or Fedora 29+ appliance is required for properrun"
        exit 1
fi

## timezone of hypervisor
timezone=$(readlink /etc/localtime | sed 's/^.*zoneinfo\/\(.*\)$/\1/')

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/a10vg/root_lv -m /dev/sda2:/boot --selinux <<EOF
# change the hostname of machine
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
# allow SSH password login
sh 'sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config'
# change timezone of machine to match hypervisor
sh 'rm -f /etc/localtime'
sh 'ln -s /usr/share/zoneinfo/$timezone /etc/localtime'
# disable default sshd PerSourcePenalties to allow rapid ssh-keyscan
sh 'echo "PerSourcePenalties no" > /etc/ssh/sshd_config.d/60-disable-PerSourcePenalties.conf'
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/localtime
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/hostname
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/ssh/sshd_config
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/ssh/sshd_config.d/60-disable-PerSourcePenalties.conf
EOF
