#!/bin/bash
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')

# detect the slot where network card is as system uses hardware-based names for network interfaces

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/sda2:/ -m /dev/sda1:/boot <<EOF
sh 'echo "$VM_HOSTNAME" > /etc/hostname'
sh 'echo -e "PermitRootLogin yes\nPerSourcePenalties no" > /etc/ssh/sshd_config.d/01-allow-root.conf'
sh 'echo "root:testtest" | chpasswd >/dev/null'
sh 'ln -s /usr/lib/systemd/system/sshd.service /etc/systemd/system/multi-user.target.wants/sshd.service'
EOF
