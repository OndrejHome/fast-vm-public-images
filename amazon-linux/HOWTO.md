## Repackaging guide

- Version list URL: [https://aws.amazon.com/ko/amazon-linux-2/release-notes/](https://aws.amazon.com/ko/amazon-linux-2/release-notes/)
- Download URL for particular version: [https://cdn.amazonlinux.com/os-images/2.0.20211201.0/kvm/](https://cdn.amazonlinux.com/os-images/2.0.20211201.0/kvm/)

NOTE: Using version list the 'Download URL' can be edited to download older versions.

## creating amazon-linux-2 image for fast-vm

1. Download the original image
  ~~~
  # wget https://cdn.amazonlinux.com/os-images/2.0.20211223.0/kvm/amzn2-kvm-2.0.20211223.0-x86_64.xfs.gpt.qcow2
  ~~~

2. Create empty fast-vm image 25GB in size.
  ~~~
  # fast-vm-image import_custom 25 amz2.211223 empty xml/amazon-linux-2.xml
  ...
  [__][inf] importing image empty into /dev/xxx/fastvm-amz2.211223
  ...
  ~~~

3. Convert image from QCOW2 to RAW and store it in empty fast-vm image device. NOTE: Image will allocate 100% of image size (25GB) and next step will remove empty space from it.
  ~~~
  # qemu-img convert -p -O raw amzn2-kvm-2.0.20211223.0-x86_64.xfs.gpt.qcow2 /dev/xxx/fastvm-amz2.211223
  # fast-vm-image list
  IMAGE                                |SYSTEM                |USER                  |
  Image name             Size( %used ) |XML      Hack file for|XML      Hack file for|
  ...
  amz2.211223             25g(100.00%) |missing  no hack files|ok       no hack files|
  ...
  ~~~

4. Sparsify the image using `fast-vm-image compact`.
  ~~~
  # fast-vm-image compact amz2.211223
  # fast-vm-image list
  IMAGE                                |SYSTEM                |USER                  |
  Image name             Size( %used ) |XML      Hack file for|XML      Hack file for|
  ...
  amz2.211223             25g(  4.41%) |ok       no hack files|missing  no hack files|
  ...
  ~~~

5. Export image and generate checksums for it.
  ~~~
  # fast-vm-image export amz2.211223 xz
  # fast-vm-image export amz2.211223 zst
  # fast-vm-image gen_checksums amz2.211223
  ~~~
