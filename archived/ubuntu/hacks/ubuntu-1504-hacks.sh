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

## configuration file for the serial console
TTYS0_FILE=$(mktemp --suffix=ttyS0.conf)
cat >$TTYS0_FILE <<EOF
start on stopped rc or RUNLEVEL=[2345]
stop on runlevel [!2345]

respawn
exec /sbin/getty -L 115200 ttyS0 vt102
EOF

guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/u1504vg/root_lv -m /dev/sda1:/boot <<EOF

sh 'sed -i "s/terminal_output gfxterm/serial --unit=0 --speed=115200 --word=8 --parity=no\nterminal_input serial\nterminal_output serial/; s/root_lv /root_lv console=ttyS0,115200n8 /" /boot/grub/grub.cfg'
sh 'sed -i "s/GRUB_TERMINAL_OUTPUT=\"console\"/GRUB_TERMINAL=\"serial\"\nGRUB_SERIAL_COMMAND=\"serial --speed=115200 --unit=0 --word=8 --parity=no\"/; s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"console=ttyS0,115200n8\"/" /etc/default/grub'
copy-in $TTYS0_FILE /etc/init/
sh 'sed -i "s/inet loopback/inet loopback\nauto eth0\niface eth0 inet dhcp/" /etc/network/interfaces'
sh 'sed -i "s/.*/$VM_HOSTNAME/" /etc/hostname'
EOF

rm $TTYS0_FILE
