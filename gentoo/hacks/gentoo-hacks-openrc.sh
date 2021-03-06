#!/bin/bash
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/sda3:/ -m /dev/sda1:/boot <<EOF
# setup hostname
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
# enable login on serial console
sh 'sed -i "s/^#s0/s0/" /etc/inittab'
# allow access for root to SSH
sh 'sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config'
sh 'sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config'
EOF
