#!/bin/bash

LIVE_PATH="/home/hardik/oscad-live"

export KERNEL_VERSION=`uname -r`
export IMAGE_NAME=Ubuntu-OSCAD
export ISO_MOUNT_PATH=${LIVE_PATH}/ubuntu_iso
export UBUNTU_ORIG_PATH=${LIVE_PATH}/ubuntu_1204raw
export UBUNTU_MOD_PATH=${LIVE_PATH}/ubuntu_1204mod
export UBUNTU_ISO=${LIVE_PATH}/ubuntu-OSCAD-rc4.iso
export TARGET_ISO=${LIVE_PATH}/ubuntu-OSCAD-rc5.iso

