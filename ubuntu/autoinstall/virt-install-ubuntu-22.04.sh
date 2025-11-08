#!/bin/sh
# example: ./$0 /dev/vg_ssd/fastvm-ubuntu-install /wd4tb/workdir/tmp/ISO/buntu-24.04.3-live-server-amd64.iso seed.iso
# to generate seed.iso run command below in directory with 'user-data' and 'meta-data' files
# # mkisofs -output seed.iso -volid cidata -joliet -rock user-data meta-data
BASE_IMAGE_LV="$1"
ISO_LOCATION="$2"
SEED_ISO="$3"

virt-install \
--connect qemu:///system \
--name ubuntu-fastvm-install \
--ram 2048 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-variant=ubuntu22.04 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--disk path=$SEED_ISO,format=raw,cache=none \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION,kernel=casper/vmlinuz,initrd=casper/initrd \
--extra-args="autoinstall serial text console=ttyS0,115200n8 locale=en_US keymap=us" \
--noreboot \
--nographics

virsh --connect qemu:///system undefine ubuntu-fastvm-install
