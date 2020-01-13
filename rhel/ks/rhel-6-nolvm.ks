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
part swap --fstype swap --size=256
part / --fstype=ext4 --size=5000

poweroff

%packages --nobase
@Core
%end

%post --nochroot
/mnt/sysimage/sbin/fstrim /mnt/sysimage
/mnt/sysimage/sbin/fstrim /mnt/sysimage/boot
%end
