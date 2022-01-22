#!/bin/bash
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/sda1:/ <<EOF
# enable SSH password authentication and root account
sh 'sed -i "s/^disable_root:.*/disable_root: false/; s/^ssh_pwauth:.*/ssh_pwauth: true/" /etc/cloud/cloud.cfg'
# set hostname
sh 'echo "$VM_HOSTNAME" > /etc/hostname'
# configure password to 'testtest' for 'root' and 'ec2-user'
sh 'sed -i "s/expire: false/expire: false\n   list: |\n      ec2-user:testtest\n      root:testtest/" /etc/cloud/cloud.cfg'
# enable output to serial console from grub
sh 'sed -i "s/terminal_output gfxterm/serial --unit=0 --speed=115200 --word=8 --parity=no\nterminal_input serial\nterminal_output serial/; s/root_lv /root_lv console=ttyS0,115200n8 /" /boot/grub2/grub.cfg'
sh 'echo -e "GRUB_TERMINAL=\"serial\"\nGRUB_SERIAL_COMMAND=\"serial --speed=115200 --unit=0 --word=8 --parity=no\"" >> /etc/default/grub'
# configure time zone matching the host
sh 'rm -f /etc/localtime'
sh 'ln -s /usr/share/zoneinfo/$timezone /etc/localtime'
EOF
