#!/bin/sh
# example: ./$0 /dev/vg_ssd/fastvm-rhel-6.0-ide /wd4tb/workdir/tmp/ISO/rhel-server-6.0-x86_64-dvd.iso rhel-6.ks
BASE_IMAGE_LV="$1"
ISO_LOCATION="$2"
KICKSTART="$3"

virt-install \
--connect qemu:///system \
--name rhel-6-fastvm-install \
--ram 1024 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-variant=rhel6.3 \
--disk path=$BASE_IMAGE_LV,bus=ide,format=raw \
--location $ISO_LOCATION \
--extra-args="ks=file:/$(basename $KICKSTART) nonet text console=ttyS0,115200n8" \
--initrd-inject=$KICKSTART \
--noreboot \
--nographics

virsh --connect qemu:///system undefine rhel-6-fastvm-install
