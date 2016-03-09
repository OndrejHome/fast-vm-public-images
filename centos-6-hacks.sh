#!/bin/bash

## serial console grub config
virt-edit -d $VM_NAME -m /dev/c6vg/root_lv -m /dev/sda1:/boot /boot/grub/grub.conf -e "s/default=0$/default=0 #edited\nserial --unit=0 --speed=115200 --word=8 --parity=no\nterminal --timeout=5 serial console/; s/^hiddenmenu/#hiddenmenu/; s/^splashimage/#splashimage/; s/rhgb quiet/console=ttyS0,115200n8/"

## eth0 MAC address change + enable network on boot
virt-edit -d $VM_NAME -m /dev/c6vg/root_lv -m /dev/sda1:/boot /etc/sysconfig/network-scripts/ifcfg-eth0 -e "s/HWADDR=.*$/HWADDR=${vm_mac}/; s/ONBOOT=no/ONBOOT=yes/"

## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')
virt-edit -d $VM_NAME -m /dev/c6vg/root_lv -m /dev/sda1:/boot /etc/sysconfig/network -e "s/HOSTNAME=.*$/HOSTNAME=$VM_HOSTNAME/"
