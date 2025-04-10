## creating config.ign for FCOS

[Fedora CoreOS - Producing an Ignition File](https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/)

## creating FCOS image for fast-vm
At this point image is a converted QEMU qcow2.xz image with basic Ignition file.

1. Get the QEMU qcow2.xz image and unpack it (~2GB space is needed) - [Download Fedora CoreOS](https://getfedora.org/coreos/download?tab=metal_virtualized&stream=stable)
  ~~~
  # wget https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/41.20241215.3.0/x86_64/fedora-coreos-41.20241215.3.0-qemu.x86_64.qcow2.xz
  # unxz fedora-coreos-41.20241215.3.0-qemu.x86_64.qcow2.xz
  ~~~

2. Create empty fast-vm image of size 10GB (to match the size of qcow2 image)
  ~~~
  # qemu-img info fedora-coreos-41.20241215.3.0-qemu.x86_64.qcow2 |grep 'virtual size'
  virtual size: 10 GiB (10737418240 bytes)
  ~~~
  ~~~
  # fast-vm-image import_custom 10 fcos41.241215 empty ../xml/fcos-40.xml
  ...
  [__][inf] importing image empty into /dev/xxx/fastvm-fcos41.241215
  ...
  ~~~

3. Convert image from QCOW2 to RAW and store it in empty fast-vm image device. NOTE: image will allocate 100% of image size and next steps will remove empty space from there. To enable access to `/dev/xxx/fastvm-fcos41.241215` as normal user you can run `fast-vm-image compact fcos41.241215` that has side effect of allowing user access.
  ~~~
  # qemu-img convert -p -O raw fedora-coreos-41.20241215.3.0-qemu.x86_64.qcow2 /dev/xxx/fastvm-fcos41.241215
  ~~~
  ~~~
  # fast-vm-image list
  IMAGE                                |SYSTEM                |USER                  |
  Image name             Size( %used ) |XML      Hack file for|XML      Hack file for|
  ...
  fcos41.241215           10g(100.00%) |missing  no hack files|ok       no hack files|
  ...
  ~~~

4. Determine location of `/boot` and modify the image to include the basic Ignition file from this repository
  ~~~
  # LIBGUESTFS_BACKEND=direct guestfish -a /dev/xxx/fastvm-fcos41.241215 << EOF
  run
  list-filesystems
  EOF
  /dev/sda1: unknown
  /dev/sda2: vfat
  /dev/sda3: ext4       <------
  /dev/sda4: xfs
  ~~~
  ~~~
  # LIBGUESTFS_BACKEND=direct guestfish -a /dev/xxx/fastvm-fcos41.241215 -m /dev/sda3 << EOF
  mkdir /ignition
  copy-in fcos-41/config.ign /ignition
  EOF
  ~~~

5. (1/2) sparsify image: use `fast-vm-image compact` to cleanup free space on filesystems.
  ~~~
  # fast-vm-image compact fcos41.241215
  ~~~

6. (2/2) sparsify image: tell thinpool to remove all space after last partition. First determine where last partition ends and then tell `blkdiscard` to remove everything after that location. NOTE: this will also remove backup GPT table from disk which will get automatically regenerated by Ignition when automatically resizing the partitions.
  ~~~
  # fdisk -l /dev/xxx/fastvm-fcos41.241215 |grep -E 'Units|Device|p4'
  GPT PMBR size mismatch (5427199 != 20971519) will be corrected by write.
  The backup GPT table is not on the end of the device.
  Units: sectors of 1 * 512 = 512 bytes
  Device                               Start     End Sectors  Size Type
  /dev/vg_477/fastvm-fcos41.241215p4 1050624 5425151 4374528  2.1G Linux filesystem
  ~~~
  NOTE: in some cases the `fdisk` may improperly detect the unit size showing only one partition (PMBR), in such case `fdisk -b 512 -l /dev/xxx/fastvm-fcos41.241215` can be used to get proper view (this was observed on aarch64 system).
  ~~~
  # echo "(5425151+1)*512"|bc
  2777677824
  ~~~
  ~~~
  # blkdiscard -o 2777677824 -f /dev/xxx/fastvm-fcos41.241215
  blkdiscard: Operation forced, data will be lost!
  ~~~
  ~~~
  # fast-vm-image list|grep fcos41.241215
  fcos41.241215           10g( 17.55%) |missing  no hack files|ok       no hack files|
  ~~~

7. Export image and generate checksums for it.
  ~~~
  # fast-vm-image export fcos41.241215 zst
  # fast-vm-image gen_checksums fcos41.241215
  ~~~
