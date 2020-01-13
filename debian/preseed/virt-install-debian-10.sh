#!/bin/sh
# example: ./$0 /dev/vg_ssd/fastvm-debian-install /wd4tb/workdir/tmp/ISO/debian-10.0.0-amd64-DVD-1.iso debian-10.preseed
BASE_IMAGE_LV="$1"
ISO_LOCATION="$2"
KICKSTART="$3"

virt-install \
--connect qemu:///system \
--name debian-fastvm-install \
--ram 1024 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-type=linux  --os-variant=debian9 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION \
--extra-args="auto file=/$(basename $KICKSTART) text console=ttyS0,115200n8 locale=en_US keymap=us" \
--initrd-inject=$KICKSTART \
--noreboot \
--nographics

virsh --connect qemu:///system undefine debian-fastvm-install
