## Fedora CoreOS
- images area based on QEMU qcow2.xz image
- to access VM via console and SSH use
  - user: root
  - pass: testtest
- system is provided with custom 'config.ign' Ignition file that configures following:
  - password login for 'root' via SSH
  - root password
  - generic hostname 'fastvm-fcos'
  - config for zincati to disable auto-updates
