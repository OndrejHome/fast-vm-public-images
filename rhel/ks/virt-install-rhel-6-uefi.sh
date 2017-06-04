#!/bin/sh
# example: ./$0 /dev/vg_ssd/fastvm-rhel-6.9 /wd4tb/workdir/tmp/ISO/rhel-server-6.9-x86_64-dvd.iso rhel-6-uefi.ks
BASE_IMAGE_LV="$1"
ISO_LOCATION="$2"
KICKSTART="$3"

virt-install \
--connect qemu:///system \
--name rhel-6-uefi-fastvm-install \
--ram 1024 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-type=linux  --os-variant=rhel6.3 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION \
--extra-args="ks=file:/$KICKSTART nonet text console=ttyS0,115200n8" \
--initrd-inject=$KICKSTART \
--noreboot \
--boot uefi \
--nographics

cp /var/lib/libvirt/qemu/nvram/rhel-6-uefi-fastvm-install_VARS.fd rhel-6_VARS.fd-$(basename $ISO_LOCATION)
virsh --connect qemu:///system undefine --nvram rhel-6-uefi-fastvm-install
