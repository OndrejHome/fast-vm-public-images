install
cdrom
text
key --skip
lang en_US.UTF-8
keyboard us
network --onboot no --device eth0 --bootproto dhcp
rootpw testtest
firewall --enabled --port=22:tcp
authconfig --enableshadow --enablemd5
selinux --enforcing
timezone --utc Europe/Prague
bootloader --location=mbr --driveorder=hda

zerombr
clearpart --none --drives=hda

part /boot --fstype ext3 --size=100 --ondisk=hda
part pv.1 --size=0 --grow --ondisk=hda
volgroup r5vg --pesize=32768 pv.1
logvol swap --fstype swap --name=swap_lv --vgname=r5vg --size=256
logvol / --fstype ext3 --name=root_lv --vgname=r5vg --size=4992

poweroff

%packages
@base
@core
