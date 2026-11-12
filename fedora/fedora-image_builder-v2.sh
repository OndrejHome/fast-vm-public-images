#!/bin/bash
ISO_DIR="/mnt/iso_storage/fedora"

../image_builder-v2.sh build fedora45 6 ks/virt-install-fedora-43-nvme.sh "$ISO_DIR/Fedora-Server-dvd-x86_64-45-1.4.iso" ks/fedora-45.ks | tee 1_build-fedora45.log
../image_builder-v2.sh test fedora45 44 xml/fedora-28-current.xml hacks/6g_fedora-45-hacks.sh ../image_builder_test_script-v2.sh 30| tee 2_test-fedora45.log
../image_builder-v2.sh test fedora45 44 xml/fedora-37-current-nvme.xml hacks/6g_fedora-45-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-fedora45-nvme.log

../image_builder-v2.sh build fedora45uefi 6 ks/virt-install-fedora-43-uefi.sh "$ISO_DIR/Fedora-Server-dvd-x86_64-45-1.4.iso" ks/fedora-45-uefi.ks | tee 1_build-f45-uefi.log
../image_builder-v2.sh test fedora45uefi 44 xml/fedora-37-current-uefi.xml hacks/6g_fedora-45-hacks.sh ../image_builder_test_script-v2.sh 30 | tee 2_test_fedora45uefi.log
