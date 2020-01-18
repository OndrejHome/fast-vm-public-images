#!/bin/bash
ISO_DIR="/mnt/iso-storage/fedora"
#===
./image_builder.sh build f28 fedora/ks/virt-install-fedora.sh "$ISO_DIR/Fedora-Server-dvd-x86_64-28-1.1.iso" fedora/ks/fedora-28.ks | tee 1_build-f28.log
./image_builder.sh build f29 fedora/ks/virt-install-fedora.sh "$ISO_DIR/Fedora-Server-dvd-x86_64-29-1.2.iso" fedora/ks/fedora-29.ks | tee 1_build-f29.log
./image_builder.sh build f30 fedora/ks/virt-install-fedora.sh "$ISO_DIR/Fedora-Server-dvd-x86_64-30-1.2.iso" fedora/ks/fedora-30.ks | tee 1_build-f30.log
./image_builder.sh build f31 fedora/ks/virt-install-fedora.sh "$ISO_DIR/Fedora-Server-dvd-x86_64-31-1.9.iso" fedora/ks/fedora-31.ks | tee 1_build-f31.log
#===
./image_builder.sh test f28 42 fedora/xml/fedora-28-current.xml fedora/hacks/6g_fedora-29-hacks.sh | tee 2_test_f28.log
./image_builder.sh test f29 42 fedora/xml/fedora-28-current.xml fedora/hacks/6g_fedora-29-hacks.sh | tee 2_test_f29.log
./image_builder.sh test f30 42 fedora/xml/fedora-28-current.xml fedora/hacks/6g_fedora-30-hacks.sh | tee 2_test_f30.log
./image_builder.sh test f31 42 fedora/xml/fedora-28-current.xml fedora/hacks/6g_fedora-31-hacks.sh | tee 2_test_f31.log
#===
