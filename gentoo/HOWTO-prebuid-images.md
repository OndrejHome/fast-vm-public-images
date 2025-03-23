## Adapting prebuild images for fast-vm
https://www.gentoo.org/news/2025/02/20/gentoo-qcow2-images.html

1. Get the `QCOW2 disk (no root pw)` image - https://www.gentoo.org/downloads/
  ~~~
  # wget https://distfiles.gentoo.org/releases/amd64/autobuilds/20250315T023326Z/di-amd64-console-20250315T023326Z.qcow2
  ~~~

2. Create empty fast-vm image of size 20GB (to match the size of qcow2 image)
  ~~~
  # qemu-img info di-amd64-console-20250315T023326Z.qcow2
  image: di-amd64-console-20250315T023326Z.qcow2
  file format: qcow2
  virtual size: 20 GiB (21474836480 bytes)
  disk size: 1.03 GiB
  cluster_size: 65536
  Format specific information:
      compat: 1.1
      compression type: zlib
      lazy refcounts: false
      refcount bits: 16
      corrupt: false
      extended l2: false
  Child node '/file':
      filename: di-amd64-console-20250315T023326Z.qcow2
      protocol type: file
      file length: 1.03 GiB (1100677120 bytes)
      disk size: 1.03 GiB
  ~~~
  ~~~
  # fast-vm-image import_custom 20 gentoo250315 empty xml/gentoo-uefi.xml
  ...
  [__][inf] importing image empty into /dev/xxx/fastvm-gentoo250315
  ...
  ~~~

3. Convert image from QCOW2 to RAW and store it in empty fast-vm image device. NOTE: image will allocate 100% of image size and next steps will remove empty space from there. To enable access to `/dev/xxx/fastvm-gentoo250315` as normal user you can run `fast-vm-image compact fastvm-gentoo250315` that has side effect of allowing user access.
  ~~~
  # qemu-img convert -p -O raw di-amd64-console-20250315T023326Z.qcow2 /dev/xxx/fastvm-gentoo250315
  ~~~
  ~~~
  # fast-vm-image list
  IMAGE                                |SYSTEM                |USER                  |
  Image name             Size( %used ) |XML      Hack file for|XML      Hack file for|
  ...
  gentoo250315            20g(100.00%) |missing  no hack files|ok       no hack files|
  ...
  ~~~

4. Sparsify image: use `fast-vm-image compact` to cleanup free space on filesystems.
  ~~~
  # fast-vm-image compact gentoo250315
  ~~~
  ~~~
  # fast-vm-image list|grep gentoo250315
  gentoo250315            20g( 14.02%) |missing  no hack files|ok       no hack files|
  ~~~

5. Export image and generate checksums for it.
  ~~~
  # fast-vm-image export gentoo250315 zst
  # fast-vm-image gen_checksums gentoo250315
  ~~~
