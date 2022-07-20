#!/bin/sh
# example: ./$0 /dev/vg_ssd/fastvm-rocky-9.0 /wd4tb/workdir/tmp/ISO/Rocky-9.0-x86_64-dvd.iso rocky-9.ks
BASE_IMAGE_LV="$1"
ISO_LOCATION="$2"
KICKSTART="$3"

virt-install \
--connect qemu:///system \
--name rocky-9-fastvm-install \
--ram 1024 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-variant=rocky9.0 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION \
--extra-args="inst.ks=file:/$(basename $KICKSTART) nonet inst.text console=ttyS0,115200n8" \
--initrd-inject=$KICKSTART \
--noreboot \
--nographics

virsh --connect qemu:///system undefine rocky-9-fastvm-install
