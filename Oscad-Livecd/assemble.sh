#!/bin/bash

source vars.sh

umount ${UBUNTU_MOD_PATH}/dev

chmod +w ${UBUNTU_ORIG_PATH}/casper/filesystem.manifest

chroot ${UBUNTU_MOD_PATH} dpkg-query -W \
--showformat='${Package} ${Version}\n' \
> ${UBUNTU_ORIG_PATH}/casper/filesystem.manifest

cp -v ${UBUNTU_ORIG_PATH}/casper/filesystem.manifest \
${UBUNTU_ORIG_PATH}/casper/filesystem.manifest-desktop

sed -i '/ubiquity/d' ${UBUNTU_ORIG_PATH}/casper/filesystem.manifest-desktop
sed -i '/casper/d' ${UBUNTU_ORIG_PATH}/casper/filesystem.manifest-desktop

rm ${UBUNTU_ORIG_PATH}/casper/filesystem.squashfs
mksquashfs ${UBUNTU_MOD_PATH} ${UBUNTU_ORIG_PATH}/casper/filesystem.squashfs

printf $(sudo du -sx --block-size=1 ${UBUNTU_MOD_PATH} | cut -f1) \
> ${UBUNTU_ORIG_PATH}/casper/filesystem.size

nano ${UBUNTU_ORIG_PATH}/README.diskdefines

wait

cd ${UBUNTU_ORIG_PATH}
rm md5sum.txt
find -type f -print0 \
   | xargs -0 md5sum \
   | grep -v isolinux/boot.cat \
   | tee md5sum.txt

mkisofs \
   -D \
   -r \
   -V "$IMAGE_NAME" \
   -cache-inodes \
   -J \
   -l \
   -b isolinux/isolinux.bin \
   -c isolinux/boot.cat \
   -no-emul-boot \
   -boot-load-size 4 \
   -boot-info-table \
   -o ${TARGET_ISO} .
