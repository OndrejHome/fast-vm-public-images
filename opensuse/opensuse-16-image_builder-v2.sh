#!/bin/bash
ISO_DIR="/mnt/iso_storage/opensuse"

# OpenSuse 16.1 Leap BIOS
../image_builder-v2.sh build os-16.1 6 agama/virt-install-opensuse-16.sh "$ISO_DIR/Leap-16.1-offline-installer-x86_64.install.iso" agama/leap-16-standard.json |tee 1_build-os-16.1.log
../image_builder-v2.sh test os-16.1 44 xml/opensuse-15.xml hacks/6g_opensuse-16-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-os-16.1.log
../image_builder-v2.sh test os-16.1 44 xml/opensuse-15-nvme.xml hacks/6g_opensuse-16-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-os-16.1-nvme.log
