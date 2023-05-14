#!/bin/bash
# example: ./$0 /dev/vg_ssd/fastvm-fedora-install /wd4tb/workdir/tmp/ISO/Fedora-Server-dvd-aarch64.iso fedora.ks
BASE_IMAGE_LV="$1"
ISO_LOCATION="$2"
KICKSTART="$3"

virt-install \
--connect qemu:///system \
--name fedora-38-uefi-fastvm-install \
--ram 1536 --cpu host-passthrough --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-variant=fedora37 \
--machine virt-7.2 \
--features gic.version=3 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION \
--extra-args="inst.ks=file:/$(basename $KICKSTART) nonet inst.text console=ttyS0,115200n8" \
--initrd-inject=$KICKSTART \
--noreboot \
--boot uefi \
--nographics

virsh --connect qemu:///system undefine --nvram fedora-38-uefi-fastvm-install
