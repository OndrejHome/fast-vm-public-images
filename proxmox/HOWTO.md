## HOWTO generate proxmox image using virt-install
NOTE: automated installation seems to be present only recently from proxmox version 8.2, previous version 8.1 seems to not have one.

Temporarily the proxmox system is needed to generate ISO image capable of booting automated installation using answer.toml file on separate disk from ISO.

- (on temporary proxmox system) configure repositories that don't require subscription to obtain needed packages
~~~
# rm /etc/apt/sources.list.d/pve-enterprise.list
# echo 'deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription' > /etc/apt/sources.list.d/pve-no-subscription.list
# apt-get update
~~~
- (on temporary proxmox system) generate the ISO image that will attempt to load `answer.toml` file from partition labeled `PROXMOX-AIS` (by default it tries to search for that file on ISO file from which it booted).
~~~
# apt install proxmox-auto-install-assistant
# proxmox-auto-install-assistant prepare-iso proxmox-ve_8.2-1.iso --fetch-from partition
Copying source ISO to temporary location...
Preparing ISO...
Moving prepared ISO to target location...
Final ISO is available at "proxmox-ve_8.2-1-auto-from-partition.iso".
~~~
- (on regular linux system) generate ISO file that will contain the `answer.toml`
~~~
# cd answer
# mkisofs -o proxmox-8.2-answer.iso -J -R -V PROXMOX-AIS answer.toml 
~~~
- (on regular linux system) run the installation using answer file embeded in ISO
~~~
# fast-vm-image import_custom 10 proxmox-8.2 empty xml/proxmox-8.xml 
# ./answer/virt-install-proxmox.sh /dev/vg_477/fastvm-proxmox-8.2 /mnt/iso_storage/proxmox/proxmox-ve_8.2-1-auto-from-partition.iso answer/proxmox-8-answer.iso
~~~
- (on regular linux system) compact and export finished image
~~~
# fast-vm-image compact proxmox-8.2
# fast-vm-image export proxmox-8.2 zst
# fast-vm-image gen_checksums proxmox-8.2 
~~~
