#!/bin/bash

# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# --------------------
# FILE_ORIGINAL_NAME: extract-file.sh
# FILE_ORIGINAL_PATH: B2G/device/geeksphone/keon
# ---

# What is this script?
# After running './config keon', 'build.sh' calls this script to pull
# required libraries from geeksphone/keon and starts the build
# process. The pulled files are libs/blobs without which the
# compilation fails. One has to attach the device via USB and should
# have 'adb' installed for this script to work.

# Why I modified it?
# I do all the build process on server(Server is located elsewhere, I
# access it remotely) because it is way faster than my development
# machine and thus saves time. The build process fails as it does not
# find device attached to server. The only way is to pull '/system'
# from the device manually, copy it to build server and re-run
# 'build.sh'

# My present device's '/system' path is: /home/sachin/keon/backup/

DEVICE=keon
MANUFACTURER=geeksphone

if [[ -z "${ANDROIDFS_DIR}" && -d ../../../backup-${DEVICE}/system ]]; then
    ANDROIDFS_DIR=../../../backup-${DEVICE}
fi

if [[ -z "${ANDROIDFS_DIR}" ]]; then
    echo Pulling files from device
    DEVICE_BUILD_ID=`cat /home/sachin/keon/backup/system/build.prop | grep ro.build.display.id | sed -e 's/ro.build.display.id=//' | tr -d '\n\r'`
else
    echo Pulling files from ${ANDROIDFS_DIR}
    DEVICE_BUILD_ID=`cat ${ANDROIDFS_DIR}/system/build.prop | grep ro.build.display.id | sed -e 's/ro.build.display.id=//' | tr -d '\n\r'`
fi

echo Found firmware with build ID $DEVICE_BUILD_ID >&2

if [[ ! -d ../../../backup-${DEVICE}/system  && -z "${ANDROIDFS_DIR}" ]]; then
    echo Backing up system partition to backup-${DEVICE}
    mkdir -p ../../../backup-${DEVICE} &&
    cp -rv /home/sachin/keon/backup/system ../../../backup-${DEVICE}/system
    cp ../../../backup-${DEVICE}/system/etc/wifi/WCN* ../../../backup-${DEVICE}/system/etc/firmware/wlan/volans
fi

BASE_PROPRIETARY_DEVICE_DIR=vendor/$MANUFACTURER/$DEVICE/proprietary
PROPRIETARY_DEVICE_DIR=../../../$BASE_PROPRIETARY_DEVICE_DIR

mkdir -p $PROPRIETARY_DEVICE_DIR

for NAME in adreno hw wifi etc
do
    mkdir -p $PROPRIETARY_DEVICE_DIR/$NAME
done

DEVICE_BLOBS_LIST=../../../vendor/$MANUFACTURER/$DEVICE/vendor-blobs.mk

(cat << EOF) | sed s/__DEVICE__/$DEVICE/g | sed s/__MANUFACTURER__/$MANUFACTURER/g > $DEVICE_BLOBS_LIST
# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Prebuilt libraries that are needed to build open-source libraries
PRODUCT_COPY_FILES := device/sample/etc/apns-full-conf.xml:system/etc/apns-conf.xml

# All the blobs
PRODUCT_COPY_FILES += \\
EOF

# copy_files_to_obj_lib
# Add blob into out/target/product/XXX/obj/lib for compile time checking by some files.
# In order to copy the same file into two different destination path by PRODUCT_COPY_FILES,
# this function duplicate candidate to another name then add it into PRODUCT_COPY_FILES.
# Then change candidate to original name in target of PRODUCT_COPY_FILES.
# $1 = src name
# $2 = additional path under $PROPRIETARY_DEVICE_DIR
copy_files_to_obj_lib()
{
    for NAME in $1
    do
        if [[ -f $PROPRIETARY_DEVICE_DIR/$2/$NAME ]]; then
            cp $PROPRIETARY_DEVICE_DIR/$2/$NAME "$PROPRIETARY_DEVICE_DIR/$2/obj$NAME"
            echo $BASE_PROPRIETARY_DEVICE_DIR/$2/obj$NAME:obj/lib/$NAME \\ >> $DEVICE_BLOBS_LIST
        else
            echo Failed to copy $1 from existing backup blobs to obj/lib. Giving up.
            exit -1
        fi
    done
}

# copy_file
# pull file from the device and adds the file to the list of blobs
#
# $1 = src name
# $2 = dst name
# $3 = directory path on device
# $4 = directory name in $PROPRIETARY_DEVICE_DIR
copy_file()
{
    echo Pulling \"$1\"
    if [[ -z "${ANDROIDFS_DIR}" ]]; then
        cp -vr /$3/$1 $PROPRIETARY_DEVICE_DIR/$4/$2
    else
        cp ${ANDROIDFS_DIR}/$3/$1 $PROPRIETARY_DEVICE_DIR/$4/$2
    fi

    if [[ -f $PROPRIETARY_DEVICE_DIR/$4/$2 ]]; then
        echo   $BASE_PROPRIETARY_DEVICE_DIR/$4/$2:$3/$2 \\ >> $DEVICE_BLOBS_LIST
    else
        echo Failed to pull $1. Giving up.
        exit -1
    fi
}

# copy_files
# pulls a list of files from the device and adds the files to the list of blobs
#
# $1 = list of files
# $2 = directory path on device
# $3 = directory name in $PROPRIETARY_DEVICE_DIR
copy_files()
{
    for NAME in $1
    do
        copy_file "$NAME" "$NAME" "$2" "$3"
    done
}

# copy_local_files
# puts files in this directory on the list of blobs to install
#
# $1 = list of files
# $2 = directory path on device
# $3 = local directory path
copy_local_files()
{
    for NAME in $1
    do
        echo Adding \"$NAME\"
        echo device/$MANUFACTURER/$DEVICE/$3/$NAME:$2/$NAME \\ >> $DEVICE_BLOBS_LIST
    done
}

DEVICE_LIBS="
	libaudioeq.so
	libauth.so
	libcm.so
	libcommondefs.so
	libdiag.so
	libDivxDrm.so
	libdivxdrmdecrypt.so
	libdsi_netctrl.so
	libdsm.so
	libdss.so
	libdsucsd.so
	libdsutils.so
	libgps.utils.so
	libidl.so
	libloc_adapter.so
	libloc_api-rpc-qc.so
	libloc_eng.so
	libloc_ext.so
	libmmipl.so
	libmmparser.so
	libmmosal.so
	libnetmgr.so
	libnv.so
	liboemcamera.so
	libgemini.so
	liboncrpc.so
	libpbmlib.so
	libqdi.so
	libqdp.so
	libqmi.so
	libqmiservices.so
	libqueue.so
	libril-qc-1.so
	libril-qc-qmi-1.so
	libril-qcril-hook-oem.so
	libwms.so
	libwmsts.so
	libCommandSvc.so
	libmmgsdilib.so
	libmm-adspsvc.so
	libmm-abl-oem.so
	libmm-abl.so
	libOmxAacDec.so
	libOmxAmrEnc.so
	libOmxEvrcDec.so
	libOmxOn2Dec.so
	libOmxrv9Dec.so
	libOmxWmvDec.so
	libOmxAacEnc.so
	libOmxAmrRtpDec.so
	libOmxEvrcEnc.so
	libOmxQcelp13Dec.so
	libOmxVidEnc.so
	libOmxAdpcmDec.so
	libOmxAmrwbDec.so
	libOmxEvrcHwDec.so
	libOmxMp3Dec.so
	libOmxQcelp13Enc.so
	libOmxVp8Dec.so
	libOmxAmrDec.so
	libOmxCore.so
	libOmxH264Dec.so
	libOmxMpeg4Dec.so
	libOmxQcelpHwDec.so
	libOmxWmaDec.so
	libcnefeatureconfig.so
	libmmjpeg.so
	librpc.so
	libmemalloc.so
	"

copy_files "$DEVICE_LIBS" "home/sachin/keon/backup/system/lib" ""

COMMON_OBJ_LIBS="
	libcnefeatureconfig.so
	libmmjpeg.so
	"

copy_files_to_obj_lib "$COMMON_OBJ_LIBS" ""

DEVICE_BINS="
	abtfilt
	akmd8963
	amploader
	bridgemgrd
	fmconfig
	fm_qsoc_patches
	hci_qcomm_init
	radish
	netmgrd
	port-bridge
	qmiproxy
	qmuxd
	rmt_storage
	"

copy_files "$DEVICE_BINS" "home/sachin/keon/backup/system/bin" ""

DEVICE_HW="
	camera.msm7627a.so
	sensors.msm7627a.so
	gps.default.so
	"

copy_files "$DEVICE_HW" "home/sachin/keon/backup/system/lib/hw" "hw"

DEVICE_WLAN_ATH="
	athtcmd_ram.bin
	bdata.bin
	fw-3.bin
	nullTestFlow.bin
	utf.bin
	"	
copy_files "$DEVICE_WLAN_ATH" "home/sachin/keon/backup/system/etc/firmware/ath6k/AR6003/hw2.1.1" "wifi"

DEVICE_ETC="
	init.qcom.bt.sh
	AudioFilter.csv
	init.qcom.wifi.sh
	"
copy_files "$DEVICE_ETC" "home/sachin/keon/backup/system/etc" "etc"

LIB_ADRENO="
	libgsl.so
	libOpenVG.so
	libsc-a2xx.so
	libC2D2.so
	"
copy_files "$LIB_ADRENO" "home/sachin/keon/backup/system/lib" "adreno"

LIB_EGL_ADRENO="
	egl.cfg
	eglsubAndroid.so
	libEGL_adreno200.so
	libGLES_android.so
	libGLESv1_CM_adreno200.so
	libGLESv2_adreno200.so
	libq3dtools_adreno200.so
	"
copy_files "$LIB_EGL_ADRENO" "home/sachin/keon/backup/system/lib/egl" "adreno"

LIB_FW_ADRENO="
	yamato_pm4.fw
	yamato_pfp.fw
	"
copy_files "$LIB_FW_ADRENO" "home/sachin/keon/backup/system/etc/firmware" "adreno"
