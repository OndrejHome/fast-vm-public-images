#!/bin/bash
ISO_DIR="/mnt/iso_storage/rhel"

# RHEL 9.9 BIOS
../image_builder-v2.sh build rhel-9.9 6 ks/virt-install-rhel-9-nvme.sh "$ISO_DIR/rhel-9.9-x86_64-dvd.iso" ks/rhel-9.ks |tee 1_build-rhel-9.9.log
../image_builder-v2.sh test rhel-9.9 44 xml/rhel-9.0-current.xml hacks/6g_rhel-9-hacks.sh ../image_builder_test_script-v2.sh 30 | tee 2_test-rhel-9.9.log
../image_builder-v2.sh test rhel-9.9 44 xml/rhel-9.0-current-nvme.xml hacks/6g_rhel-9-hacks.sh ../image_builder_test_script-v2.sh 30 | tee 2_test-rhel-9.9-nvme.log

# RHEL 9.9 UEFI
../image_builder-v2.sh build rhel-9.9-uefi 6 ks/virt-install-rhel-9-uefi.sh "$ISO_DIR/rhel-9.9-x86_64-dvd.iso" ks/rhel-9-uefi.ks |tee 1_build-rhel-9.9-uefi.log
../image_builder-v2.sh test rhel-9.9-uefi 44 xml/rhel-7.0-current-uefi.xml hacks/6g_rhel-9-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee 2_test-rhel-9.9-uefi.log

# RHEL 10.3 BIOS
../image_builder-v2.sh build rhel-10.3 6 ks/virt-install-rhel-10-nvme.sh "$ISO_DIR/rhel-10.3-x86_64-dvd.iso" ks/rhel-10.ks |tee 1_build-rhel-10.3.log
../image_builder-v2.sh test rhel-10.3 44 xml/rhel-9.0-current.xml hacks/6g_rhel-10-hacks.sh ../image_builder_test_script-v2.sh 30 | tee 2_test-rhel-10.3.log
../image_builder-v2.sh test rhel-10.3 44 xml/rhel-9.0-current-nvme.xml hacks/6g_rhel-10-hacks.sh ../image_builder_test_script-v2.sh 30 | tee 2_test-rhel-10.3-nvme.log

# RHEL 10.3 UEFI
../image_builder-v2.sh build rhel-10.3-uefi 6 ks/virt-install-rhel-10-uefi.sh "$ISO_DIR/rhel-10.3-x86_64-dvd.iso" ks/rhel-10-uefi.ks |tee 1_build-rhel-10.3-uefi.log
../image_builder-v2.sh test rhel-10.3-uefi 44 xml/rhel-9.0-current-uefi.xml hacks/6g_rhel-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee 2_test-rhel-10.3-uefi.log
