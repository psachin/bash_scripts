#!/bin/bash
# Simple script to copy Camera images from phone to ~/Pictures directory

# path inside phone to fetch files from
PHONE_PATH='/sdcard/DCIM/Camera/'
# path where to save file(s)
DESTINATION="${HOME}/Pictures/zte/"


PICS=$(adb shell ls ${PHONE_PATH})
for image in ${PICS}; 
do
    #echo ${image}
    # remove trailing '\r' if any
    IMAGE=`echo ${image} | tr -d '\r'`
    echo "Pulling image: ${PHONE_PATH}${IMAGE}"
    adb pull ${PHONE_PATH}${IMAGE}
    echo "Moving to ${DESTINATION}"
    rsync \
	--verbose \
	--progress \
	--remove-source-files \
	${IMAGE} \
	${DESTINATION}
done 


# BUG: moves all files ??

    # 	--checksum \
    # 	--recursive \
    # 	--update \
    # 	--times \
    # 	--human-readable \
