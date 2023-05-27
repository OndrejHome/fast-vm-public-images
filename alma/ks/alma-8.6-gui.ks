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
# System services
services --disabled="chronyd"
# Configure the X Window System
xconfig --startxonboot
# System timezone
timezone Europe/London --isUtc --nontp
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
# Partition clearing information
clearpart --none --initlabel
# Disk partitioning information
part pv.1 --fstype="lvmpv" --ondisk=sda --size=1 --grow
part /boot --fstype="xfs" --ondisk=sda --size=500
volgroup a8vg --pesize=4096 pv.1
logvol swap  --fstype="swap" --size=256 --name=swap_lv --vgname=a8vg
logvol /  --fstype="xfs" --size=6000 --name=root_lv --vgname=a8vg

%packages
@^graphical-server-environment
kexec-tools
-iwl*-firmware
-alsa-sof-firmware
-libertas-usb8388-firmware
%end

%addon com_redhat_kdump --enable --reserve-mb='192M'

%end

%post --log=/root/ks-post.log
dnf remove -y linux-firmware
/sbin/fstrim -a -v
%end
