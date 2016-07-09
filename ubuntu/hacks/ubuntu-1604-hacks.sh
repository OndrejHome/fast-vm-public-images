#!/bin/bash

## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct

## serial console grub2
virt-edit --connect qemu:///system -d $VM_NAME -m /dev/u1604vg/root_lv -m /dev/sda1:/boot /boot/grub/grub.cfg -e "s/terminal_output gfxterm/serial --unit=0 --speed=115200 --word=8 --parity=no\nterminal_input serial\nterminal_output serial/; s/root_lv /root_lv console=ttyS0,115200n8 /"
virt-edit --connect qemu:///system -d $VM_NAME -m /dev/u1604vg/root_lv -m /dev/sda1:/boot /etc/default/grub -e "s/GRUB_TERMINAL_OUTPUT=\"console\"/GRUB_TERMINAL=\"serial\"\nGRUB_SERIAL_COMMAND=\"serial --speed=115200 --unit=0 --word=8 --parity=no\"/; s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"console=ttyS0,115200n8\"/"

## activate ens3 on boot
virt-edit --connect qemu:///system -d $VM_NAME -m /dev/u1604vg/root_lv -m /dev/sda1:/boot /etc/network/interfaces -e "s/inet loopback/inet loopback\nauto ens3\niface ens3 inet dhcp/"

## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')
virt-edit --connect qemu:///system -d $VM_NAME -m /dev/u1604vg/root_lv -m /dev/sda1:/boot /etc/hostname -e "s/.*/$VM_HOSTNAME/"
