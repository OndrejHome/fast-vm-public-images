#!/bin/bash
ISO_DIR="/mnt/iso-storage/debian"

## Debian 9.x
#===
./image_builder.sh build d93 debian/preseed/virt-install-debian-9.sh "$ISO_DIR/debian-9.3.0-amd64-DVD-1.iso" debian/preseed/debian-9.preseed | tee 1_build-d93.log
./image_builder.sh build d94 debian/preseed/virt-install-debian-9.sh "$ISO_DIR/debian-9.4.0-amd64-DVD-1.iso" debian/preseed/debian-9.preseed | tee 1_build-d94.log
./image_builder.sh build d95 debian/preseed/virt-install-debian-9.sh "$ISO_DIR/debian-9.5.0-amd64-DVD-1.iso" debian/preseed/debian-9.preseed | tee 1_build-d95.log
./image_builder.sh build d97 debian/preseed/virt-install-debian-9.sh "$ISO_DIR/debian-9.7.0-amd64-DVD-1.iso" debian/preseed/debian-9.preseed | tee 1_build-d97.log
./image_builder.sh build d98 debian/preseed/virt-install-debian-9.sh "$ISO_DIR/debian-9.8.0-amd64-DVD-1.iso" debian/preseed/debian-9.preseed | tee 1_build-d98.log
./image_builder.sh build d99 debian/preseed/virt-install-debian-9.sh "$ISO_DIR/debian-9.9.0-amd64-DVD-1.iso" debian/preseed/debian-9.preseed | tee 1_build-d99.log
./image_builder.sh build d911 debian/preseed/virt-install-debian-9.sh "$ISO_DIR/debian-9.11.0-amd64-DVD-1.iso" debian/preseed/debian-9.preseed | tee 1_build-d911.log
#===
./image_builder.sh test d93 42 debian/xml/debian-9.xml debian/hacks/debian-9.sh | tee 2_test_d93.log
./image_builder.sh test d94 42 debian/xml/debian-9.xml debian/hacks/debian-9.sh | tee 2_test_d94.log
./image_builder.sh test d95 42 debian/xml/debian-9.xml debian/hacks/debian-9.sh | tee 2_test_d95.log
./image_builder.sh test d97 42 debian/xml/debian-9.xml debian/hacks/debian-9.sh | tee 2_test_d97.log
./image_builder.sh test d98 42 debian/xml/debian-9.xml debian/hacks/debian-9.sh | tee 2_test_d98.log
./image_builder.sh test d99 42 debian/xml/debian-9.xml debian/hacks/debian-9.sh | tee 2_test_d99.log
./image_builder.sh test d911 42 debian/xml/debian-9.xml debian/hacks/debian-9.sh | tee 2_test_d911.log
#===

## Debian 10.x
#===
./image_builder.sh build d100 debian/preseed/virt-install-debian-10.sh "$ISO_DIR/debian-10.0.0-amd64-DVD-1.iso" debian/preseed/debian-10.preseed | tee 1_build-d100.log
./image_builder.sh build d101 debian/preseed/virt-install-debian-10.sh "$ISO_DIR/debian-10.1.0-amd64-DVD-1.iso" debian/preseed/debian-10.preseed | tee 1_build-d101.log
./image_builder.sh build d102 debian/preseed/virt-install-debian-10.sh "$ISO_DIR/debian-10.2.0-amd64-DVD-1.iso" debian/preseed/debian-10.preseed | tee 1_build-d102.log
#===
./image_builder.sh test d100 42 debian/xml/debian-10.xml debian/hacks/debian-10.sh | tee 2_test_d100.log
./image_builder.sh test d101 42 debian/xml/debian-10.xml debian/hacks/debian-10.sh | tee 2_test_d101.log
./image_builder.sh test d102 42 debian/xml/debian-10.xml debian/hacks/debian-10.sh | tee 2_test_d102.log
#===
