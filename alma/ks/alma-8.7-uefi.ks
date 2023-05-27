#version=DEVEL
# Use CDROM installation media
cdrom
# Use text mode install
text
# Run the Setup Agent on first boot
firstboot --disable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --xlayouts='us'
# System language
lang en_US.UTF-8

# Shutdown after installation
shutdown
# Root password
rootpw --plaintext testtest
# System services
services --disabled="chronyd"
# Do not configure the X Window System
skipx
# System timezone
timezone Europe/London --isUtc --nontp
# Partition clearing information
clearpart --none --initlabel
# Disk partitioning information
part /boot/efi --fstype="efi" --ondisk=sda --size=200 --fsoptions="umask=0077,shortname=winnt"
part pv.1 --fstype="lvmpv" --ondisk=sda --size=1 --grow
part /boot --fstype="xfs" --ondisk=sda --size=512
volgroup a8vg --pesize=4096 pv.1
logvol swap --fstype="swap" --size=256 --name=swap_lv --vgname=a8vg
logvol / --fstype="xfs" --size=5120 --name=root_lv --vgname=a8vg

%packages
@^minimal-environment
kexec-tools
-iwl*-firmware
%end

%addon com_redhat_kdump --enable --reserve-mb='192M'

%end

%post --log=/root/ks-post.log
dnf remove -y linux-firmware
/sbin/fstrim -a -v
%end
