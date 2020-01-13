#version=DEVEL
install
text
cdrom
lang en_US.UTF-8
keyboard us
network --onboot no --device eth0 --bootproto dhcp --noipv6
rootpw  --plaintext testtest
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
timezone --utc Europe/London
bootloader --location=mbr --driveorder=sda --append="crashkernel=128M"
# The following is the partition information you requested
# Note that any partitions you deleted are not expressed
# here so unless you clear all partitions first, this is
# not guaranteed to work
zerombr
clearpart --none --drives=sda

part /boot --fstype=ext4 --size=500
part pv.1 --grow --size=1
volgroup o6vg --pesize=4096 pv.1
logvol swap --name=swap_lv --vgname=o6vg --size=256
logvol / --fstype=ext4 --name=root_lv --vgname=o6vg --size=5000

poweroff

%packages
@base
@client-mgmt-tools
@core
@debugging
@basic-desktop
@desktop-debugging
@desktop-platform
@directory-client
@fonts
@general-desktop
@graphical-admin-tools
@input-methods
@internet-browser
@java-platform
@legacy-x
@network-file-system-client
@perl-runtime
@print-client
@remote-desktop-clients
@server-platform
@server-policy
@uek4-kernel-repo
@x11
mtools
pax
python-dmidecode
oddjob
wodim
sgpio
genisoimage
device-mapper-persistent-data
abrt-gui
samba-winbind
certmonger
pam_krb5
krb5-workstation
libXmu
perl-DBD-SQLite
-ql23xx-firmware
-netxen-firmware
-bfa-firmware
-rt73usb-firmware
-iwl5150-firmware
-iwl100-firmware
-iwl6050-firmware
-iwl6000g2a-firmware
-ql2200-firmware
-iwl3945-firmware
-rt61pci-firmware
-iwl4965-firmware
-ql2500-firmware
-iwl6000-firmware
-libertas-usb8388-firmware
-ivtv-firmware
-ql2100-firmware
-iwl5000-firmware
-ql2400-firmware
-iwl1000-firmware
-kernel-firmware
%end

%post --nochroot
/mnt/sysimage/sbin/fstrim /mnt/sysimage
/mnt/sysimage/sbin/fstrim /mnt/sysimage/boot
%end
