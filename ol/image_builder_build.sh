#!/bin/bash
ISO_DIR="/mnt/iso-storage/oraclelinux"

## Oracle Linux 6.x
#===
./image_builder.sh build o63 ol/ks/virt-install-ol-6.sh "$ISO_DIR/OracleLinux-R6-U3-Server-x86_64-dvd.iso" ol/ks/ol-6.ks |tee 1_build-o63.log
./image_builder.sh build o64 ol/ks/virt-install-ol-6.sh "$ISO_DIR/OracleLinux-R6-U4-Server-x86_64-dvd.iso" ol/ks/ol-6.ks |tee 1_build-o64.log
./image_builder.sh build o65 ol/ks/virt-install-ol-6.sh "$ISO_DIR/OracleLinux-R6-U5-Server-x86_64-dvd.iso" ol/ks/ol-6.ks |tee 1_build-o65.log
./image_builder.sh build o66 ol/ks/virt-install-ol-6.sh "$ISO_DIR/OracleLinux-R6-U6-Server-x86_64-dvd.iso" ol/ks/ol-6.ks |tee 1_build-o66.log
./image_builder.sh build o67 ol/ks/virt-install-ol-6.sh "$ISO_DIR/OracleLinux-R6-U7-Server-x86_64-dvd.iso" ol/ks/ol-6.ks |tee 1_build-o67.log
./image_builder.sh build o68 ol/ks/virt-install-ol-6.sh "$ISO_DIR/OracleLinux-R6-U8-Server-x86_64-dvd.iso" ol/ks/ol-6.ks |tee 1_build-o68.log
./image_builder.sh build o69 ol/ks/virt-install-ol-6.sh "$ISO_DIR/OracleLinux-R6-U9-Server-x86_64-dvd.iso" ol/ks/ol-6.ks |tee 1_build-o69.log
#
#TODO UEFI
#===
./image_builder.sh test o63 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-6-hacks.sh | tee 2_test-o63.log
./image_builder.sh test o64 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-6-hacks.sh | tee 2_test-o64.log
./image_builder.sh test o65 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-6-hacks.sh | tee 2_test-o65.log
./image_builder.sh test o66 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-6-hacks.sh | tee 2_test-o66.log
./image_builder.sh test o67 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-6-hacks.sh | tee 2_test-o67.log
./image_builder.sh test o68 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-6-hacks.sh | tee 2_test-o68.log
./image_builder.sh test o69 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-6-hacks.sh | tee 2_test-o69.log
#
#===

## Oracle Linux 7.x
#===
./image_builder.sh build o70 ol/ks/virt-install-ol-7.sh "$ISO_DIR/OracleLinux-R7-U0-Server-x86_64-dvd.iso" ol/ks/ol-7.0.ks |tee 1_build-o70.log
./image_builder.sh build o71 ol/ks/virt-install-ol-7.sh "$ISO_DIR/OracleLinux-R7-U1-Server-x86_64-dvd.iso" ol/ks/ol-7.1.ks |tee 1_build-o71.log
./image_builder.sh build o72 ol/ks/virt-install-ol-7.sh "$ISO_DIR/OracleLinux-R7-U2-Server-x86_64-dvd.iso" ol/ks/ol-7.1.ks |tee 1_build-o72.log
./image_builder.sh build o73 ol/ks/virt-install-ol-7.sh "$ISO_DIR/OracleLinux-R7-U3-Server-x86_64-dvd.iso" ol/ks/ol-7.1.ks |tee 1_build-o73.log
./image_builder.sh build o74 ol/ks/virt-install-ol-7.sh "$ISO_DIR/OracleLinux-R7-U4-Server-x86_64-dvd.iso" ol/ks/ol-7.1.ks |tee 1_build-o74.log
./image_builder.sh build o75 ol/ks/virt-install-ol-7.sh "$ISO_DIR/OracleLinux-R7-U5-Server-x86_64-dvd.iso" ol/ks/ol-7.1.ks |tee 1_build-o75.log
./image_builder.sh build o76 ol/ks/virt-install-ol-7.sh "$ISO_DIR/OracleLinux-R7-U6-Server-x86_64-dvd.iso" ol/ks/ol-7.1.ks |tee 1_build-o76.log
./image_builder.sh build o77 ol/ks/virt-install-ol-7.sh "$ISO_DIR/OracleLinux-R7-U7-Server-x86_64-dvd.iso" ol/ks/ol-7.1.ks |tee 1_build-o77.log
#
./image_builder.sh build o72-uefi ol/ks/virt-install-ol-7-uefi.sh "$ISO_DIR/OracleLinux-R7-U2-Server-x86_64-dvd.iso" ol/ks/ol-7.1-uefi.ks |tee 1_build-o72-uefi.log
./image_builder.sh build o73-uefi ol/ks/virt-install-ol-7-uefi.sh "$ISO_DIR/OracleLinux-R7-U3-Server-x86_64-dvd.iso" ol/ks/ol-7.1-uefi.ks |tee 1_build-o73-uefi.log
./image_builder.sh build o74-uefi ol/ks/virt-install-ol-7-uefi.sh "$ISO_DIR/OracleLinux-R7-U4-Server-x86_64-dvd.iso" ol/ks/ol-7.1-uefi.ks |tee 1_build-o74-uefi.log
./image_builder.sh build o75-uefi ol/ks/virt-install-ol-7-uefi.sh "$ISO_DIR/OracleLinux-R7-U5-Server-x86_64-dvd.iso" ol/ks/ol-7.1-uefi.ks |tee 1_build-o75-uefi.log
./image_builder.sh build o76-uefi ol/ks/virt-install-ol-7-uefi.sh "$ISO_DIR/OracleLinux-R7-U6-Server-x86_64-dvd.iso" ol/ks/ol-7.1-uefi.ks |tee 1_build-o76-uefi.log
./image_builder.sh build o77-uefi ol/ks/virt-install-ol-7-uefi.sh "$ISO_DIR/OracleLinux-R7-U7-Server-x86_64-dvd.iso" ol/ks/ol-7.1-uefi.ks |tee 1_build-o77-uefi.log
#===
./image_builder.sh test o70 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-7-hacks.sh | tee 2_test-o70.log
./image_builder.sh test o71 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-7-hacks.sh | tee 2_test-o71.log
./image_builder.sh test o72 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-7-hacks.sh | tee 2_test-o72.log
./image_builder.sh test o73 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-7-hacks.sh | tee 2_test-o73.log
./image_builder.sh test o74 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-7-hacks.sh | tee 2_test-o74.log
./image_builder.sh test o75 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-7-hacks.sh | tee 2_test-o75.log
./image_builder.sh test o76 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-7-hacks.sh | tee 2_test-o76.log
./image_builder.sh test o77 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-7-hacks.sh | tee 2_test-o77.log
#
./image_builder.sh test o72-uefi 42 ol/xml/ol-7.1-current-uefi.xml ol/hacks/6g_ol-7-hacks-uefi.sh | tee 2_test-o72-uefi.log
./image_builder.sh test o73-uefi 42 ol/xml/ol-7.1-current-uefi.xml ol/hacks/6g_ol-7-hacks-uefi.sh | tee 2_test-o73-uefi.log
./image_builder.sh test o74-uefi 42 ol/xml/ol-7.1-current-uefi.xml ol/hacks/6g_ol-7-hacks-uefi.sh | tee 2_test-o74-uefi.log
./image_builder.sh test o75-uefi 42 ol/xml/ol-7.1-current-uefi.xml ol/hacks/6g_ol-7-hacks-uefi.sh | tee 2_test-o75-uefi.log
./image_builder.sh test o76-uefi 42 ol/xml/ol-7.1-current-uefi.xml ol/hacks/6g_ol-7-hacks-uefi.sh | tee 2_test-o76-uefi.log
./image_builder.sh test o77-uefi 42 ol/xml/ol-7.1-current-uefi.xml ol/hacks/6g_ol-7-hacks-uefi.sh | tee 2_test-o77-uefi.log
#===

## Oracle Linux 8.x
#===
./image_builder.sh build o80 ol/ks/virt-install-ol-8.sh "$ISO_DIR/OracleLinux-R8-U0-x86_64-dvd.iso" ol/ks/ol-8.ks |tee 1_build-o80.log
./image_builder.sh build o81 ol/ks/virt-install-ol-8.sh "$ISO_DIR/OracleLinux-R8-U1-x86_64-dvd.iso" ol/ks/ol-8.ks |tee 1_build-o81.log
#
./image_builder.sh build o80-uefi ol/ks/virt-install-ol-8-uefi.sh "$ISO_DIR/OracleLinux-R8-U0-x86_64-dvd.iso" ol/ks/ol-8-uefi.ks |tee 1_build-o80-uefi.log
./image_builder.sh build o81-uefi ol/ks/virt-install-ol-8-uefi.sh "$ISO_DIR/OracleLinux-R8-U1-x86_64-dvd.iso" ol/ks/ol-8-uefi.ks |tee 1_build-o81-uefi.log
#===
./image_builder.sh test o80 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-8-hacks.sh | tee 2_test-o80.log
./image_builder.sh test o81 42 ol/xml/ol-6.3-current.xml ol/hacks/6g_ol-8-hacks.sh | tee 2_test-o81.log
#
./image_builder.sh test o80-uefi 42 ol/xml/ol-7.1-current-uefi.xml ol/hacks/6g_ol-8-hacks-uefi.sh | tee 2_test-o80-uefi.log
./image_builder.sh test o81-uefi 42 ol/xml/ol-7.1-current-uefi.xml ol/hacks/6g_ol-8-hacks-uefi.sh | tee 2_test-o81-uefi.log
#===
