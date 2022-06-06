#!/bin/sh
# example: ./$0 /dev/vg_ssd/fastvm-os-15.3 /mnt/iso_storage/opensuse/openSUSE-Leap-15.3-3-DVD-x86_64-Media.iso autoyast.xml
BASE_IMAGE_LV="$1"
ISO_LOCATION="$2"
KICKSTART="$3"

virt-install \
--connect qemu:///system \
--name opensuse-15-fastvm-install \
--ram 1024 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-variant=opensuse15.3 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION \
--extra-args="autoyast=file:///$(basename $KICKSTART) textmode=1 console=ttyS0,115200n8" \
--initrd-inject=$KICKSTART \
--noreboot \
--nographics

virsh --connect qemu:///system undefine opensuse-15-fastvm-install
