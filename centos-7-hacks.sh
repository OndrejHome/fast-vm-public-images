#!/bin/bash
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/c7vg/root_lv -m /dev/sda1:/boot --selinux <<EOF
sh /usr/sbin/load_policy
mkdir /root/.ssh
sh 'restorecon /root/.ssh/'
sh 'sed -i "s/ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-eth0'
sh 'sed -i "s/terminal_output console/serial --unit=0 --speed=115200 --word=8 --parity=no\nterminal_input serial\nterminal_output serial/; s/rhgb quiet/console=ttyS0,115200n8/" /boot/grub2/grub.cfg'
sh 'sed -i "s/GRUB_TERMINAL_OUTPUT=\"console\"/GRUB_TERMINAL=\"serial\"\nGRUB_SERIAL_COMMAND=\"serial --speed=115200 --unit=0 --word=8 --parity=no\"/; s/rhgb quiet/console=ttyS0,115200n8/" /etc/default/grub'
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
EOF
