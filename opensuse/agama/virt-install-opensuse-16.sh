#!/bin/sh
# example: ./$0 /dev/vg_ssd/fastvm-opensuse-install /wd4tb/workdir/tmp/ISO/Leap-16.0-offline-installer-x86_64.install.iso leap-16-standard.json
# to generate seed.iso run command below in directory with 'leap-16-standard.json'
# # mkisofs -output seed.iso -volid agama -joliet -rock leap-16-standard.json
BASE_IMAGE_LV="$1"
ISO_LOCATION="$2"
AGAMA_JSON="$3"

virt-install \
--connect qemu:///system \
--name opensuse-fastvm-install \
--ram 2048 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--os-variant=opensuse16.0 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--disk path=agama/seed.iso,format=raw,cache=none \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION,kernel=boot/x86_64/loader/linux,initrd=boot/x86_64/loader/initrd \
--extra-args="inst.auto=LABEL://agama/$(basename $AGAMA_JSON) console=ttyS0,115200n8" \
--noreboot \
--nographics

virsh --connect qemu:///system undefine opensuse-fastvm-install
