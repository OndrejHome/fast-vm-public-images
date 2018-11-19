#!/bin/bash
## test if guestfish command is present
which guestfish 2>&1 > /dev/null
if [ "$?" != 0 ]; then
	echo "[!!!] Command 'guestfish' not found (Install it!). Making changes to VM FAILED."
	exit 1
fi
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')

if [ ! -f /etc/fedora-release ]; then
        if [ -d /var/tmp/fedora29/appliance ]; then
                export LIBGUESTFS_PATH=/var/tmp/fedora29/appliance
        else
                echo "[!!!] Non-Fedora systems needs a Fedora 29 (or newer) appliance in /var/tmp/fedora29/appliance to run"
                exit 1
        fi
fi

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/r8vg/root_lv -m /dev/sda1:/boot --selinux <<EOF
# enable eth0 adapter on boot
sh 'sed -i "s/ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-enp0s2'
# change the hostname of machine
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/sysconfig/network-scripts/ifcfg-enp0s2
selinux-relabel /etc/selinux/targeted/contexts/files/file_contexts /etc/hostname
EOF