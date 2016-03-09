#!/bin/bash

## serial console grub2
virt-edit -d $VM_NAME -m /dev/u1510vg/root_lv -m /dev/sda1:/boot /boot/grub/grub.cfg -e "s/terminal_output gfxterm/serial --unit=0 --speed=115200 --word=8 --parity=no\nterminal_input serial\nterminal_output serial/; s/root_lv /root_lv console=ttyS0,115200n8 /"
virt-edit -d $VM_NAME -m /dev/u1510vg/root_lv -m /dev/sda1:/boot /etc/default/grub -e "s/GRUB_TERMINAL_OUTPUT=\"console\"/GRUB_TERMINAL=\"serial\"\nGRUB_SERIAL_COMMAND=\"serial --speed=115200 --unit=0 --word=8 --parity=no\"/; s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"console=ttyS0,115200n8\"/"

## configuration file for the serial console
TTYS0_FILE=$(mktemp --suffix=ttyS0.conf)
cat >$TTYS0_FILE <<EOF
start on stopped rc or RUNLEVEL=[2345]
stop on runlevel [!2345]

respawn
exec /sbin/getty -L 115200 ttyS0 vt102
EOF
virt-copy-in -d $VM_NAME $TTYS0_FILE /etc/init/
rm $TTYS0_FILE

## activate eth0 on boot
virt-edit -d $VM_NAME -m /dev/u1510vg/root_lv -m /dev/sda1:/boot /etc/network/interfaces -e "s/inet loopback/inet loopback\nauto eth0\niface eth0 inet dhcp/"

## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')
virt-edit -d $VM_NAME -m /dev/u1510vg/root_lv -m /dev/sda1:/boot /etc/hostname -e "s/.*/$VM_HOSTNAME/"
