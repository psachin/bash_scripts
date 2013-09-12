#!/bin/bash

source vars.sh

echo "removing previous directories"
rm -rvf ${ISO_MOUNT_PATH} 
rm -rvf ${UBUNTU_ORIG_PATH} 
rm -rvf ${UBUNTU_MOD_PATH}

echo "making new directories"
mkdir -pv ${UBUNTU_ORIG_PATH}
mkdir -pv ${ISO_MOUNT_PATH}

echo "mounting ISO..."
mount -o loop ${UBUNTU_ISO} ${ISO_MOUNT_PATH}

echo "extracting ISO content..."
rsync --exclude=/casper/filesystem.squashfs -av ${ISO_MOUNT_PATH}/ ${UBUNTU_ORIG_PATH}
 
echo "extract the squashfs file"
unsquashfs -i -d ${UBUNTU_MOD_PATH} ${ISO_MOUNT_PATH}/casper/filesystem.squashfs

echo "Preparing chroot environment"
cp -v /etc/resolv.conf ${UBUNTU_MOD_PATH}/etc/
cp -v /etc/hosts ${UBUNTU_MOD_PATH}/etc/

mount --bind /dev/ ${UBUNTU_MOD_PATH}/dev

echo "chroot'ing"
chroot ${UBUNTU_MOD_PATH}

