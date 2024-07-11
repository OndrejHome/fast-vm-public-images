#!/bin/sh
# example: ./$0 /dev/vg_ssd/fastvm-cent-7.3 /wd4tb/workdir/tmp/ISO/CentOS-7-x86_64-DVD-1611.iso centos-7.ks
BASE_IMAGE_LV="$1"
ISO_LOCATION="$2"
KICKSTART="$3"

virt-install \
--connect qemu:///system \
--name centos-10-fastvm-install \
--ram 2048 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-variant=rhel9.0 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION \
--extra-args="inst.ks=file:/$(basename $KICKSTART) nonet inst.text console=ttyS0,115200n8" \
--initrd-inject=$KICKSTART \
--noreboot \
--nographics

virsh --connect qemu:///system undefine centos-10-fastvm-install
