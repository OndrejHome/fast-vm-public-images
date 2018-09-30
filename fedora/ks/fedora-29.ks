#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Install OS instead of upgrade
install
# Use CDROM installation media
cdrom
# Use text mode install
text
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Shutdown after installation
shutdown
# Root password
rootpw --plaintext testtest
# System services
services --enabled="chronyd"
# Do not configure the X Window System
skipx
# System timezone
timezone Europe/Prague --isUtc
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
# Partition clearing information
clearpart --none --initlabel
# Disk partitioning information
part pv.1 --fstype="lvmpv" --ondisk=sda --size=1 --grow
part /boot --fstype="ext4" --ondisk=sda --size=500
volgroup f29 --pesize=4096 pv.1
logvol swap  --fstype="swap" --size=256 --name=swap_lv --vgname=f29
logvol /  --fstype="xfs" --size=5000 --name=root_lv --vgname=f29

%packages
@^custom-environment

%end

%addon com_redhat_kdump --disable --reserve-mb='128'

%end

%post --nochroot
/sbin/fstrim /mnt/sysimage
/sbin/fstrim /mnt/sysimage/boot
%end
