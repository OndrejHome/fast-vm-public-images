#!/bin/sh
# example: ./$0 /dev/vg_ssd/fastvm-rhel-9.0 /mnt/iso_storage/rhel/rhel-baseos-9.0-x86_64-dvd.iso rhel-9.ks
BASE_IMAGE_LV="$1"
ISO_LOCATION="$2"
KICKSTART="$3"

VM_NAME=$(mktemp -u -p /tmp fast-vm-install-XXXXXX |sed 's#/tmp/##')

virt-install \
--connect qemu:///system \
--name $VM_NAME \
--ram 2048 --cpu host-model-only --vcpus 2 \
--network network=default,model=virtio,link_state=down,mac=52:54:00:00:be:ef \
--check mac_in_use=off \
--os-variant=rhel9.0 \
--disk path=$BASE_IMAGE_LV,bus=scsi,discard=unmap,format=raw \
--disk pool=tmp,size=1,bus=nvme,format=raw,readonly=true,serial=MAINDISK \
--controller scsi,model=virtio-scsi \
--location $ISO_LOCATION \
--extra-args="inst.ks=file:/$(basename $KICKSTART) nonet inst.text console=ttyS0,115200n8" \
--initrd-inject=$KICKSTART \
--noreboot \
--nographics

virsh --connect qemu:///system undefine $VM_NAME
virsh --connect qemu:///system vol-delete --pool tmp --vol ${VM_NAME}.img
