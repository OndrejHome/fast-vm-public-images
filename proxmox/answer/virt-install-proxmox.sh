#!/bin/sh
# example: ./$0 /dev/vg_ssd/fastvm-proxmox-install /mnt/iso/proxmox-ve_8.2-1-auto-from-partition.iso /tmp/proxmox-8-answer.iso
BASE_IMAGE_LV="$1"
ISO_LOCATION="$2"
ANSWER_ISO="$3"

virt-install \
--connect qemu:///system \
--name proxmox-fastvm-install \
--ram 1024 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-variant=debian12 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--disk path=$ANSWER_ISO,bus=sata \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION,kernel=boot/linux26,initrd=boot/initrd.img \
--extra-args="ro ramdisk_size=16777216 rw proxmox-start-auto-installer console=ttyS0,115200n8" \
--noreboot \
--nographics

virsh --connect qemu:///system undefine proxmox-fastvm-install
