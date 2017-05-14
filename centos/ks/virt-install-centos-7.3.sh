#!/bin/sh
BASE_IMAGE_LV=/dev/virt/fastvm-vinst2
ISO_LOCATION=/mnt/large_data/ISO/CentOS-7-x86_64-DVD-1611.iso

virt-install \
--connect qemu:///system \
--name centos-7.3-install \
--ram 1024 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-type=linux  --os-variant=centos7.0 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION \
--extra-args="ks=file:/centos-7.3.ks nonet text console=ttyS0,115200n8" \
--initrd-inject=centos-7.3.ks \
--noreboot \
--nographics

virsh --connect qemu:///system undefine centos-7.3-install
