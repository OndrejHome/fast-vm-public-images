#!/bin/bash
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')

# detect the slot where network card is as system uses hardware-based names for network interfaces
net_card_slot=$(virsh --connect qemu:///system dumpxml $VM_NAME|xmllint --xpath "//interface[.//source[@network='$LIBVIRT_NETWORK']]/address/@slot" - 2>/dev/null|cut -d\" -f 2|head -1|cut -dx -f 2)
net_card=$(($net_card_slot+0))

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/sda3:/ -m /dev/sda1:/boot <<EOF
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
sh 'sed -i "s/Name=.*/Name=ens${net_card}/g" /etc/systemd/network/default.network'
sh 'sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config'
sh 'sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config'
EOF
