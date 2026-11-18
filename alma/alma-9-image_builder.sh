#!/bin/bash
ISO_DIR="/mnt/iso_storage/almalinux"

# AlmaLinux 9.9 BIOS

../image_builder-v2.sh build alma-9.9 6 ks/virt-install-alma-9-nvme.sh "$ISO_DIR/AlmaLinux-9.9-x86_64-dvd.iso" ks/alma-9.ks |tee 1_build-alma-9.9.log
../image_builder-v2.sh test alma-9.9 44 xml/alma-8.3-current.xml hacks/6g_alma-9-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-9.9.log
../image_builder-v2.sh test alma-9.9 44 xml/alma-8.3-current-nvme.xml hacks/6g_alma-9-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-9.9-nvme.log

# AlmaLinux 9.9 UEFI

../image_builder-v2.sh build alma-9.9-uefi 6 ks/virt-install-alma-9-uefi-nvme.sh "$ISO_DIR/AlmaLinux-9.9-x86_64-dvd.iso" ks/alma-9-uefi.ks |tee 1_build-alma-9.9-uefi.log
../image_builder-v2.sh test alma-9.9-uefi 44 xml/alma-8.7-current-uefi.xml hacks/6g_alma-9-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-9.9-uefi.log
../image_builder-v2.sh test alma-9.9-uefi 44 xml/alma-8.7-current-uefi-nvme.xml hacks/6g_alma-9-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-9.9-uefi-nvme.log

# =====

