#!/bin/bash
ISO_DIR="/mnt/iso-storage/centos"

## CentOS 6.x
#===
./image_builder.sh build c63 centos/ks/virt-install-centos-6.sh "$ISO_DIR/CentOS-6.3-x86_64-bin-DVD1.iso" centos/ks/centos-6.ks |tee 1_build-c63.log
./image_builder.sh build c64 centos/ks/virt-install-centos-6.sh "$ISO_DIR/CentOS-6.4-x86_64-bin-DVD1.iso" centos/ks/centos-6.ks |tee 1_build-c64.log
./image_builder.sh build c65 centos/ks/virt-install-centos-6.sh "$ISO_DIR/CentOS-6.5-x86_64-bin-DVD1.iso" centos/ks/centos-6.ks |tee 1_build-c65.log
./image_builder.sh build c66 centos/ks/virt-install-centos-6.sh "$ISO_DIR/CentOS-6.6-x86_64-bin-DVD1.iso" centos/ks/centos-6.ks |tee 1_build-c66.log
./image_builder.sh build c67 centos/ks/virt-install-centos-6.sh "$ISO_DIR/CentOS-6.7-x86_64-bin-DVD1.iso" centos/ks/centos-6.ks |tee 1_build-c67.log
./image_builder.sh build c68 centos/ks/virt-install-centos-6.sh "$ISO_DIR/CentOS-6.8-x86_64-bin-DVD1.iso" centos/ks/centos-6.ks |tee 1_build-c68.log
./image_builder.sh build c69 centos/ks/virt-install-centos-6.sh "$ISO_DIR/CentOS-6.9-x86_64-bin-DVD1.iso" centos/ks/centos-6.ks |tee 1_build-c69.log
./image_builder.sh build c610 centos/ks/virt-install-centos-6.sh "$ISO_DIR/CentOS-6.10-x86_64-bin-DVD1.iso" centos/ks/centos-6.ks |tee 1_build-c610.log
#===
./image_builder.sh test c63 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-6-hacks.sh | tee 2_test-c63.log
./image_builder.sh test c64 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-6-hacks.sh | tee 2_test-c64.log
./image_builder.sh test c65 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-6-hacks.sh | tee 2_test-c65.log
./image_builder.sh test c66 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-6-hacks.sh | tee 2_test-c66.log
./image_builder.sh test c67 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-6-hacks.sh | tee 2_test-c67.log
./image_builder.sh test c68 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-6-hacks.sh | tee 2_test-c68.log
./image_builder.sh test c69 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-6-hacks.sh | tee 2_test-c69.log
./image_builder.sh test c610 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-6-hacks.sh | tee 2_test-c610.log
#===

## CentOS 7.x
#===
./image_builder.sh build c70 centos/ks/virt-install-centos-7.sh "$ISO_DIR/CentOS-7.0-1406-x86_64-DVD.iso" centos/ks/centos-7.0.ks |tee 1_build-c70.log
./image_builder.sh build c71 centos/ks/virt-install-centos-7.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1503-01.iso" centos/ks/centos-7.1.ks |tee 1_build-c71.log
./image_builder.sh build c72 centos/ks/virt-install-centos-7.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1511.iso" centos/ks/centos-7.1.ks |tee 1_build-c72.log
./image_builder.sh build c73 centos/ks/virt-install-centos-7.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1611.iso" centos/ks/centos-7.1.ks |tee 1_build-c73.log
./image_builder.sh build c74 centos/ks/virt-install-centos-7.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1708.iso" centos/ks/centos-7.1.ks |tee 1_build-c74.log
./image_builder.sh build c75 centos/ks/virt-install-centos-7.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1804.iso" centos/ks/centos-7.1.ks |tee 1_build-c75.log
./image_builder.sh build c76 centos/ks/virt-install-centos-7.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1810.iso" centos/ks/centos-7.1.ks |tee 1_build-c76.log
./image_builder.sh build c77 centos/ks/virt-install-centos-7.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1908.iso" centos/ks/centos-7.1.ks |tee 1_build-c77.log
#
./image_builder.sh build c72-uefi centos/ks/virt-install-centos-7-uefi.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1511.iso" centos/ks/centos-7.1-uefi.ks |tee 1_build-c72-uefi.log
./image_builder.sh build c73-uefi centos/ks/virt-install-centos-7-uefi.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1611.iso" centos/ks/centos-7.1-uefi.ks |tee 1_build-c73-uefi.log
./image_builder.sh build c74-uefi centos/ks/virt-install-centos-7-uefi.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1708.iso" centos/ks/centos-7.1-uefi.ks |tee 1_build-c74-uefi.log
./image_builder.sh build c75-uefi centos/ks/virt-install-centos-7-uefi.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1804.iso" centos/ks/centos-7.1-uefi.ks |tee 1_build-c75-uefi.log
./image_builder.sh build c76-uefi centos/ks/virt-install-centos-7-uefi.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1810.iso" centos/ks/centos-7.1-uefi.ks |tee 1_build-c76-uefi.log
./image_builder.sh build c77-uefi centos/ks/virt-install-centos-7-uefi.sh "$ISO_DIR/CentOS-7-x86_64-DVD-1908.iso" centos/ks/centos-7.1-uefi.ks |tee 1_build-c77-uefi.log

#===
./image_builder.sh test c70 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-7-hacks.sh | tee 2_test-c70.log
./image_builder.sh test c71 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-7-hacks.sh | tee 2_test-c71.log
./image_builder.sh test c72 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-7-hacks.sh | tee 2_test-c72.log
./image_builder.sh test c73 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-7-hacks.sh | tee 2_test-c73.log
./image_builder.sh test c74 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-7-hacks.sh | tee 2_test-c74.log
./image_builder.sh test c75 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-7-hacks.sh | tee 2_test-c75.log
./image_builder.sh test c76 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-7-hacks.sh | tee 2_test-c76.log
./image_builder.sh test c77 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-7-hacks.sh | tee 2_test-c77.log
#
./image_builder.sh test c72-uefi 42 centos/xml/centos-7.0-current-uefi.xml centos/hacks/6g_centos-7-hacks-uefi.sh | tee 2_test-c72.log
./image_builder.sh test c73-uefi 42 centos/xml/centos-7.0-current-uefi.xml centos/hacks/6g_centos-7-hacks-uefi.sh | tee 2_test-c73.log
./image_builder.sh test c74-uefi 42 centos/xml/centos-7.0-current-uefi.xml centos/hacks/6g_centos-7-hacks-uefi.sh | tee 2_test-c74.log
./image_builder.sh test c75-uefi 42 centos/xml/centos-7.0-current-uefi.xml centos/hacks/6g_centos-7-hacks-uefi.sh | tee 2_test-c75.log
./image_builder.sh test c76-uefi 42 centos/xml/centos-7.0-current-uefi.xml centos/hacks/6g_centos-7-hacks-uefi.sh | tee 2_test-c76.log
./image_builder.sh test c77-uefi 42 centos/xml/centos-7.0-current-uefi.xml centos/hacks/6g_centos-7-hacks-uefi.sh | tee 2_test-c77.log
#===

## CentOS 8.x
#===
./image_builder.sh build c80 centos/ks/virt-install-centos-8.sh "$ISO_DIR/CentOS-8-x86_64-1905-dvd1.iso" centos/ks/centos-8.ks |tee 1_build-c80.log
./image_builder.sh build c81 centos/ks/virt-install-centos-8.sh "$ISO_DIR/CentOS-8.1.1911-x86_64-dvd1.iso"  centos/ks/centos-8.ks |tee 1_build-c81.log
#
./image_builder.sh build c80-uefi centos/ks/virt-install-centos-8-uefi.sh "$ISO_DIR/CentOS-8-x86_64-1905-dvd1.iso" centos/ks/centos-8-uefi.ks |tee 1_build-c80-uefi.log
./image_builder.sh build c81-uefi centos/ks/virt-install-centos-8-uefi.sh "$ISO_DIR/CentOS-8.1.1911-x86_64-dvd1.iso"  centos/ks/centos-8-uefi.ks |tee 1_build-c81-uefi.log
#===
./image_builder.sh test c80 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-8-hacks.sh | tee 2_test-c80.log
./image_builder.sh test c81 42 centos/xml/centos-6.3-current.xml centos/hacks/6g_centos-8-hacks.sh | tee 2_test-c81.log
#
./image_builder.sh test c80-uefi 42 centos/xml/centos-7.0-current-uefi.xml centos/hacks/6g_centos-8-hacks-uefi.sh | tee 2_test-c80-uefi.log
./image_builder.sh test c81-uefi 42 centos/xml/centos-7.0-current-uefi.xml centos/hacks/6g_centos-8-hacks-uefi.sh | tee 2_test-c81-uefi.log
#===
