#!/bin/bash
## using direct backend to avoid selinux issues on fedora for now
export LIBGUESTFS_BACKEND=direct
## hostname
VM_HOSTNAME=$(echo $VM_NAME|sed -e 's/\./-/g; s/_/-/g')

echo "== customization of Centos 6.x image =="

# custom root password
echo -n "[??] root password [default: testtest]: "
read -s root_password
echo
if [ -z "$root_password" ]; then
	echo "[inf] using default 'testtest'"
fi
passwd_salt=$(echo "$VM_NAME"|md5sum)
passwd_line=$(echo "$root_password"|mkpasswd -m sha-512 -S ${passwd_salt:0:16} -s|sed 's/\//\\\//g;s/\$/\\\$/g;')

# preinstall SSH key
echo -n "[??] path to public SSH key to be used for root [default: $HOME/.ssh/id_rsa.pub]: "
read ssh_key_path
if [ -z "$ssh_key_path" ]; then
	ssh_key_path="$HOME/.ssh/id_rsa.pub"
fi
tmp_ssh_key=$(mktemp)
if [ -f "$ssh_key_path" ]; then
	echo "[inf] using SSH key from $ssh_key_path"
	cp "$ssh_key_path" $tmp_ssh_key
else
	echo "[wrn] no SSH key found, skipping"
fi

echo -n "[??] grub timeout in seconds [5]: "
read grub_timeout
if [ -z "$grub_timeout" ]; then
	echo "[inf] using default 5 seconds"
	grub_timeout=5
fi

echo "[inf] applying changes to image"
guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/c6vg/root_lv -m /dev/sda1:/boot --selinux <<EOF
sh /usr/sbin/load_policy

mkdir /root/.ssh
sh 'restorecon /root/.ssh/'
copy-in $tmp_ssh_key /root/.ssh/
mv /root/.ssh/$(basename $tmp_ssh_key) /root/.ssh/authorized_keys
chown 0 0 /root/.ssh/authorized_keys
sh 'restorecon /root/.ssh/authorized_keys'

sh 'sed -i "s/root:.*/root:$passwd_line:16291:0:::::/" /etc/shadow'
sh 'restorecon /etc/shadow'

sh 'sed -i "s/HWADDR=.*$/HWADDR=${vm_mac}/; s/ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-eth0'

sh 'sed -i "s/default=0$/default=0 #edited\nserial --unit=0 --speed=115200 --word=8 --parity=no\nterminal --timeout=5 serial console/; s/^hiddenmenu/#hiddenmenu/; s/^splashimage/#splashimage/; s/rhgb quiet/console=ttyS0,115200n8/; s/timeout=5/timeout=$grub_timeout/g" /boot/grub/grub.conf'

sh 'sed -i "s/HOSTNAME=.*$/HOSTNAME=$VM_HOSTNAME/" /etc/sysconfig/network'
EOF
