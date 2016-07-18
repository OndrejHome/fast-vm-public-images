#!/bin/bash
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/r6vg/root_lv -m /dev/sda1:/boot --selinux <<EOF
sh /usr/sbin/load_policy
sh 'sed -i "s/HWADDR=.*$/HWADDR=${VM_MAC}/; s/BOOTPROTO=.*//; s/ONBOOT=.*/ONBOOT=yes\nBOOTPROTO=dhcp/" /etc/sysconfig/network-scripts/ifcfg-eth0'
sh 'sed -i "s/default=0$/default=0 #edited\nserial --unit=0 --speed=115200 --word=8 --parity=no\nterminal --timeout=5 serial console/; s/^hiddenmenu/#hiddenmenu/; s/^splashimage/#splashimage/; s/root_lv/root_lv console=ttyS0,115200n8/; s/ rhgb//; s/ quiet//" /boot/grub/grub.conf'
sh 'sed -i "s/HOSTNAME=.*$/HOSTNAME=$VM_HOSTNAME/" /etc/sysconfig/network'
EOF
