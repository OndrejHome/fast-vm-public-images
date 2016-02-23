#!/bin/bash

## serial console grub2
virt-edit -d $VM_NAME -m /dev/c7vg/root_lv -m /dev/sda1:/boot /boot/grub2/grub.cfg -e "s/terminal_output console/serial --unit=0 --speed=115200 --word=8 --parity=no\nterminal_input serial\nterminal_output serial/; s/rhgb quiet/console=ttyS0,115200n8/"
virt-edit -d $VM_NAME -m /dev/c7vg/root_lv -m /dev/sda1:/boot /etc/default/grub -e "s/GRUB_TERMINAL_OUTPUT=\"console\"/GRUB_TERMINAL=\"serial\"\nGRUB_SERIAL_COMMAND=\"serial --speed=115200 --unit=0 --word=8 --parity=no\"/; s/rhgb quiet/console=ttyS0,115200n8/"

## activate eth0 on boot
virt-edit -d $VM_NAME -m /dev/c7vg/root_lv -m /dev/sda1:/boot /etc/sysconfig/network-scripts/ifcfg-eth0 -e "s/ONBOOT=no/ONBOOT=yes/"

## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./_/')
virt-edit -d $VM_NAME -m /dev/c7vg/root_lv -m /dev/sda1:/boot /etc/hostname -e "s/.*/$VM_HOSTNAME/"
