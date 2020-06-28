## RH CoreOS
- images area based on QEMU qcow2.gz image
- to access VM via console and SSH use
  - user: root
  - pass: testtest
- system is provided with custom 'config.ign' Ignition file that configures following:
  - password login for 'root' via SSH - customized `/etc/sshd/sshd_config`
  - root password
  - generic hostname 'fastvm-rhcos'
