#!/bin/bash
## test if guestfish command is present
which guestfish 2>&1 > /dev/null
if [ "$?" != 0 ]; then
	echo "[!!!] Command 'guestfish' not found (Install it!). Making changes to VM FAILED."
	exit 1
fi
## check if the 'system-bridge' device exists
ip a show dev system-bridge 2>&1 > /dev/null
if [ "$?" != 0 ]; then
        echo "[!!!] Device 'system-bridge' doesn't exists. Please refer to link below on how to create it."
        echo "https://www.famera.cz/blog/fast-vm/user_guide.html#exposing-fast-vm-systems-to-external-network-via-bridge"
        exit 1
fi
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')
## timezone of hypervisor
timezone=$(readlink /etc/localtime | sed 's/^.*zoneinfo\/\(.*\)$/\1/')

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/c7vg/root_lv -m /dev/sda1:/boot --selinux <<EOF
# create configuration for external network interface
cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth1
# enable eth0 adapter on boot and disable default routes on it
sh 'sed -i "s/ONBOOT=no/ONBOOT=yes/; s/DEFROUTE=.*/DEFROUTE=no/; s/IPV6_DEFROUTE=.*/IPV6_DEFROUTE=no/" /etc/sysconfig/network-scripts/ifcfg-eth0'
# change the parameter for eth1
sh 'sed -i "s/ONBOOT=no/ONBOOT=yes/; s/eth0/eth1/g; s/UUID=[a-f0-9]\{4\}/UUID=beef/" /etc/sysconfig/network-scripts/ifcfg-eth1'
# change the hostname of machine
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
# change timezone of machine to match hypervisor
sh 'rm -f /etc/localtime'
sh 'ln -s /usr/share/zoneinfo/$timezone /etc/localtime'
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/localtime
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/sysconfig/network-scripts/ifcfg-eth0
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/sysconfig/network-scripts/ifcfg-eth1
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/hostname
EOF
