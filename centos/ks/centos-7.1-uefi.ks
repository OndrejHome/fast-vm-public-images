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
# System services
services --disabled="chronyd"
# Do not configure the X Window System
skipx
# System timezone
timezone Europe/London --isUtc --nontp
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
# Partition clearing information
clearpart --none --initlabel
# Disk partitioning information
part /boot/efi --fstype="efi" --ondisk=sda --size=200 --fsoptions="umask=0077,shortname=winnt"
part pv.1 --fstype="lvmpv" --ondisk=sda --size=1 --grow
part /boot --fstype="xfs" --ondisk=sda --size=500
volgroup c7vg --pesize=4096 pv.1
logvol swap  --fstype="swap" --size=256 --name=swap_lv --vgname=c7vg
logvol /  --fstype="xfs" --size=5000 --name=root_lv --vgname=c7vg

%packages
@^minimal
@core
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='128M'

%end

%post --nochroot
/sbin/fstrim /mnt/sysimage
/sbin/fstrim /mnt/sysimage/boot
/sbin/fstrim /mnt/sysimage/boot/efi
%end
