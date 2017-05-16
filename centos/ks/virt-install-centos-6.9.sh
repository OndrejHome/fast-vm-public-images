#!/bin/sh
BASE_IMAGE_LV=/dev/vg_ssd/fastvm-cent-6.9
ISO_LOCATION=/wd4tb/workdir/tmp/CentOS-6.9-x86_64-bin-DVD1.iso

virt-install \
--connect qemu:///system \
--name centos-6.9-install \
--ram 1024 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-type=linux  --os-variant=centos6.3 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION \
--extra-args="ks=file:/centos-6.9.ks nonet text console=ttyS0,115200n8" \
--initrd-inject=centos-6.9.ks \
--noreboot \
--nographics

virsh --connect qemu:///system undefine centos-6.9-install
