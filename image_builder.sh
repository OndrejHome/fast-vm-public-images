#!/bin/bash
# This script is intended to be run as normal user on machine with fast-vm installed.
# It can build images in this repository (fast-vm-public-images) when provided with sufficient number of arguments
# additionally it is acocmpanied by 'image_builder_test_script.sh' script that is used in 'test' phase
# Typcal workflow for creating&testing images in this repository looks as follows:
# - image_builder build ...
# - image_builder test ...
# - fast-vm compact_image ...
# - fast-vm export_image ... xz
# - fast-vm export_image ... zst
# - fast-vm remove_image ...
# publish new fast-vm image on web
#
# Note: this script has now many hard-coded values. This may change in future.
if [ $# -lt 2 ]; then
	echo "Usage: $0 build ImageName InstallScript PathToISO PathToKickstart"
	echo "Usage: $0 test ImageName VMNumber PathToImageXML PathToImageHackScript"
	exit 1
fi
## functions
cleanup_vm () {
	echo "===== ImageBuilder === INFO deleting the VM"
	fast-vm delete "$1"
}
cleanup_image() {
	echo "===== ImageBuilder === INFO deleting the IMAGE"
	fast-vm remove_image "$1"
	rm /tmp/dummy.xml
}

## check the build parameters
if [ "$1" == 'build' ]; then
  ## TODO verrify number of input parameters
  IMAGE_NAME="$2"
  IMAGE_SIZE="6"
  INSTALL_SCRIPT="$3"
  ISO_FILE="$4"
  KICKSTART_FILE="$5"

  ## validate the inputs
  if [ ! -x "$INSTALL_SCRIPT" ]; then
    echo "===== ImageBuilder === ERROR $INSTALL_SCRIPT is not a file"
    exit 1
  fi
  if [ ! -f "$ISO_FILE" ]; then
    echo "===== ImageBuilder === ERROR $ISO_FILE is not a file"
    exit 1
  fi
  if [ ! -f "$KICKSTART_FILE" ]; then
    echo "===== ImageBuilder === ERROR $KICKSTART_FILE is not a file"
    exit 1
  fi

  #### MAIN TESTING
  echo "===== ImageBuilder === INFO creating empty image for build"
  touch /tmp/dummy.xml
  out=$(fast-vm import_custom_image "$IMAGE_SIZE" "$IMAGE_NAME" empty /tmp/dummy.xml)
  if [ "$?" != "0" ]; then
    echo "===== ImageBuilder === ERROR creating empty image"
    rm /tmp/dummy.xml
    exit 1
  fi
  rm /tmp/dummy.xml
  disk=$(echo "$out"|awk '/importing image empty into/ {print $NF}')
  ###
  echo "===== ImageBuilder === INFO running InstallScript on empty image BEGIN $(date)"
  date_start=$(date '+%s')
  "$INSTALL_SCRIPT" "$disk" "$ISO_FILE" "$KICKSTART_FILE"
  if [ "$?" != "0" ]; then
    echo "===== ImageBuilder === ERROR install script failed"
    cleanup_image "$IMAGE_NAME"
    exit 1
  fi
  ###
  date_end=$(date '+%s')
  echo "===== ImageBuilder === INFO running InstallScript on empty image END $(date) ($(($date_end-$date_start))s)"
  echo "===== ImageBuilder === INFO build successful"
fi
## check the test parameters
if [ "$1" == 'test' ]; then
  ## TODO verrify number of input parameters

  IMAGE_NAME="$2"
  VM_NUMBER="$3"
  XML_FILE="$4"
  HACK_FILE="$5"
  ## validate the inputs
  if [ ! -f "$XML_FILE" ]; then
    echo "===== ImageBuilder === ERROR $XML_FILE is not a file"
    exit 1
  fi
  if [ ! -f "$HACK_FILE" ]; then
    echo "===== ImageBuilder === ERROR $HACK_FILE is not a file"
    exit 1
  fi

  #### MAIN TESTING
  # create VM from image
  echo "===== ImageBuilder === INFO creating test VM $VM_NUMBER"
  fast-vm create "$IMAGE_NAME" "$VM_NUMBER" "$XML_FILE" "$HACK_FILE"
  if [ "$?" != "0" ]; then
    echo "===== ImageBuilder === ERROR creating test VM"
    exit 1
  fi

  # start VM
  echo "===== ImageBuilder === INFO starting test VM $VM_NUMBER"
  fast-vm start "$VM_NUMBER"
  if [ "$?" != "0" ]; then
    echo "===== ImageBuilder === ERROR starting test VM"
    cleanup_vm "$VM_NUMBER"
    exit 1
  fi

  # connect to VM and print `uname -a`
  echo "===== ImageBuilder === INFO running tests BEGIN $(date) with timeout 120s"
  date_start=$(date '+%s')
  USER=root PASS=testtest timeout 120 fast-vm ssh "$VM_NUMBER" ./image_builder_test_script.sh 
  if [ "$?" != "0" ]; then
    echo "===== ImageBuilder === ERROR running test command on test VM"
    cleanup_vm "$VM_NUMBER"
    exit 1
  fi
  date_end=$(date '+%s')
  echo "===== ImageBuilder === INFO running tests END $(date) ($(($date_end-$date_start))s)"
  cleanup_vm "$VM_NUMBER"
  echo "===== ImageBuilder === INFO test successful"
fi
