#!/bin/bash
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')

# determine the network card interface number based on libvirt information
net_card_slot_hex=$(virsh --connect qemu:///system dumpxml $VM_NAME|xmllint --xpath "//interface[.//source[@network='$LIBVIRT_NETWORK']]/address/@slot" - 2>/dev/null|cut -d\" -f 2|head -1)
net_card_slot=$(printf "%d" "$net_card_slot_hex") # convert hexadecimal slot number to decimal number

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/sda3:/ -m /dev/sda1:/boot <<EOF
# setup hostname
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
# enable login on serial console
sh 'sed -i "s/^#s0/s0/" /etc/inittab'
# allow access for root to SSH
sh 'sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config'
sh 'sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config'
# enable correct network card for auto start
- sh 'rm /etc/init.d/net.eth0'
sh 'ln -s /etc/init.d/net.lo /etc/init.d/net.ens${net_card_slot}'
EOF
