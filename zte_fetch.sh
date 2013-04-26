#!/bin/bash

# path inside phone to fetch files from
PHONE_PATH='/sdcard/DCIM/Camera/'
# path where to save file(s)
DESTINATION="${HOME}/Pictures/zte/"


PICS=$(adb shell ls ${PHONE_PATH})
for image in ${PICS}; 
do
    #echo ${image}
    # remove trailing '\r' if any
    IMAGE=$(echo ${image} | tr -d '\r')
    adb pull ${PHONE_PATH}${IMAGE}
    rsync \
	--verbose \
	--checksum \
	--recursive \
	--update \
	--times \
	--human-readable \
	--progress \
	--remove-source-files \
	${IMAGE} \
	${DESTINATION}
done 


# BUG: moves all files ??
