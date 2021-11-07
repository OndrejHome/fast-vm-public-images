#version=DEVEL
# Use CDROM installation media
cdrom
# Use text mode install
text
# Run the Setup Agent on first boot
firstboot --disable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Shutdown after installation
shutdown
# Root password
rootpw --plaintext testtest
# System timezone
timezone Europe/London --utc
timesource --ntp-disable
# Partition clearing information
clearpart --none --initlabel
# Disk partitioning information
part pv.1 --fstype="lvmpv" --ondisk=sda --size=1 --grow
part /boot --fstype="xfs" --ondisk=sda --size=500
volgroup f35 --pesize=4096 pv.1
logvol swap --fstype="swap" --size=256 --name=swap_lv --vgname=f35
logvol / --fstype="xfs" --size=5000 --name=root_lv --vgname=f35

%packages
@^custom-environment

%end

%post --nochroot
rm -f /mnt/sysimage/etc/NetworkManager/system-connections/*nmconnection
/sbin/fstrim /mnt/sysimage
/sbin/fstrim /mnt/sysimage/boot
%end
