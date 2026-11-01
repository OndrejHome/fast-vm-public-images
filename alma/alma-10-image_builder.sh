#!/bin/bash
ISO_DIR="/mnt/iso_storage/almalinux"

# =====

# AlmaLinux 10.0 BIOS

../image_builder-v2.sh build alma-10.0 6 ks/virt-install-alma-9-nvme.sh "$ISO_DIR/AlmaLinux-10.0-x86_64-dvd.iso" ks/alma-10.ks |tee 1_build-alma-10.0.log
../image_builder-v2.sh test alma-10.0 44 xml/alma-8.3-current.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.0.log
../image_builder-v2.sh test alma-10.0 44 xml/alma-8.3-current-nvme.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.0-nvme.log

../image_builder-v2.sh build alma-10.0v2 6 ks/virt-install-alma-9-nvme.sh "$ISO_DIR/AlmaLinux-10.0-x86_64_v2-dvd.iso" ks/alma-10.ks |tee 1_build-alma-10.0v2.log
../image_builder-v2.sh test alma-10.0v2 44 xml/alma-8.3-current.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.0v2.log
../image_builder-v2.sh test alma-10.0v2 44 xml/alma-8.3-current-nvme.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.0v2-nvme.log

# AlmaLinux 10.0 UEFI

../image_builder-v2.sh build alma-10.0-uefi 6 ks/virt-install-alma-10-uefi-nvme.sh "$ISO_DIR/AlmaLinux-10.0-x86_64-dvd.iso" ks/alma-10-uefi.ks |tee 1_build-alma-10.0-uefi.log
../image_builder-v2.sh test alma-10.0-uefi 44 xml/alma-8.7-current-uefi.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.0-uefi.log
../image_builder-v2.sh test alma-10.0-uefi 44 xml/alma-8.7-current-uefi-nvme.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.0-uefi-nvme.log

../image_builder-v2.sh build alma-10.0v2-uefi 6 ks/virt-install-alma-10-uefi-nvme.sh "$ISO_DIR/AlmaLinux-10.0-x86_64_v2-dvd.iso" ks/alma-10-uefi.ks |tee 1_build-alma-10.0v2-uefi.log
../image_builder-v2.sh test alma-10.0v2-uefi 44 xml/alma-8.7-current-uefi.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.0v2-uefi.log
../image_builder-v2.sh test alma-10.0v2-uefi 44 xml/alma-8.7-current-uefi-nvme.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.0v2-uefi-nvme.log

# =====

# AlmaLinux 10.1 BIOS

../image_builder-v2.sh build alma-10.1 6 ks/virt-install-alma-9-nvme.sh "$ISO_DIR/AlmaLinux-10.1-x86_64-dvd.iso" ks/alma-10.ks |tee 1_build-alma-10.1.log
../image_builder-v2.sh test alma-10.1 44 xml/alma-8.3-current.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.1.log
../image_builder-v2.sh test alma-10.1 44 xml/alma-8.3-current-nvme.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.1-nvme.log

../image_builder-v2.sh build alma-10.1v2 6 ks/virt-install-alma-9-nvme.sh "$ISO_DIR/AlmaLinux-10.1-x86_64_v2-dvd.iso" ks/alma-10.ks |tee 1_build-alma-10.1v2.log
../image_builder-v2.sh test alma-10.1v2 44 xml/alma-8.3-current.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.1v2.log
../image_builder-v2.sh test alma-10.1v2 44 xml/alma-8.3-current-nvme.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.1v2-nvme.log

# AlmaLinux 10.1 UEFI

../image_builder-v2.sh build alma-10.1-uefi 6 ks/virt-install-alma-10-uefi-nvme.sh "$ISO_DIR/AlmaLinux-10.1-x86_64-dvd.iso" ks/alma-10-uefi.ks |tee 1_build-alma-10.1-uefi.log
../image_builder-v2.sh test alma-10.1-uefi 44 xml/alma-8.7-current-uefi.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.1-uefi.log
../image_builder-v2.sh test alma-10.1-uefi 44 xml/alma-8.7-current-uefi-nvme.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.1-uefi-nvme.log

../image_builder-v2.sh build alma-10.1v2-uefi 6 ks/virt-install-alma-10-uefi-nvme.sh "$ISO_DIR/AlmaLinux-10.1-x86_64_v2-dvd.iso" ks/alma-10-uefi.ks |tee 1_build-alma-10.1v2-uefi.log
../image_builder-v2.sh test alma-10.1v2-uefi 44 xml/alma-8.7-current-uefi.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.1v2-uefi.log
../image_builder-v2.sh test alma-10.1v2-uefi 44 xml/alma-8.7-current-uefi-nvme.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.1v2-uefi-nvme.log

# =====

# AlmaLinux 10.2 BIOS

../image_builder-v2.sh build alma-10.2 6 ks/virt-install-alma-9-nvme.sh "$ISO_DIR/AlmaLinux-10.2-x86_64-dvd.iso" ks/alma-10.ks |tee 1_build-alma-10.2.log
../image_builder-v2.sh test alma-10.2 44 xml/alma-8.3-current.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.2.log
../image_builder-v2.sh test alma-10.2 44 xml/alma-8.3-current-nvme.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.2-nvme.log

../image_builder-v2.sh build alma-10.2v2 6 ks/virt-install-alma-9-nvme.sh "$ISO_DIR/AlmaLinux-10.2-x86_64_v2-dvd.iso" ks/alma-10.ks |tee 1_build-alma-10.2v2.log
../image_builder-v2.sh test alma-10.2v2 44 xml/alma-8.3-current.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.2v2.log
../image_builder-v2.sh test alma-10.2v2 44 xml/alma-8.3-current-nvme.xml hacks/6g_alma-10-hacks.sh ../image_builder_test_script-v2.sh 30| tee -a 2_test-alma-10.2v2-nvme.log

# AlmaLinux 10.2 UEFI

../image_builder-v2.sh build alma-10.2-uefi 6 ks/virt-install-alma-10-uefi-nvme.sh "$ISO_DIR/AlmaLinux-10.2-x86_64-dvd.iso" ks/alma-10-uefi.ks |tee 1_build-alma-10.2-uefi.log
../image_builder-v2.sh test alma-10.2-uefi 44 xml/alma-8.7-current-uefi.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.2-uefi.log
../image_builder-v2.sh test alma-10.2-uefi 44 xml/alma-8.7-current-uefi-nvme.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.2-uefi-nvme.log

../image_builder-v2.sh build alma-10.2v2-uefi 6 ks/virt-install-alma-10-uefi-nvme.sh "$ISO_DIR/AlmaLinux-10.2-x86_64_v2-dvd.iso" ks/alma-10-uefi.ks |tee 1_build-alma-10.2v2-uefi.log
../image_builder-v2.sh test alma-10.2v2-uefi 44 xml/alma-8.7-current-uefi.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.2v2-uefi.log
../image_builder-v2.sh test alma-10.2v2-uefi 44 xml/alma-8.7-current-uefi-nvme.xml hacks/6g_alma-10-hacks-uefi.sh ../image_builder_test_script-v2.sh 30 | tee -a 2_test-alma-10.2v2-uefi-nvme.log

# =====
