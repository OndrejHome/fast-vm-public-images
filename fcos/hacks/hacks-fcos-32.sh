#!/bin/bash
## if there is special directory with ignition file in /tmp then load that Ignition file to VM
if [ -f "/tmp/ignition-$vm_number/config.ign" ]; then
  echo "[inf] custom Ignition file found at /tmp/ignition-$vm_number/config.ign copying into VM /ignition/config.ign"
  export LIBGUESTFS_BACKEND=direct
# NOTE: /dev/sda1 is technically '/boot' but here is mounted as '/' for simplicity
guestfish -a "/dev/$THINPOOL_VG/$VM_NAME" -m /dev/sda1 <<EOF
copy-in /tmp/ignition-$vm_number/config.ign /ignition/
EOF
else
  echo "[inf] NOT using custom Ignition file. There is no file at /tmp/ignition-$vm_number/config.ign"
fi

