#!/bin/bash
# Unlock locked pattern of android tablets

mkdir -p /root/nande
mount /dev/nande /root/nande
python pydb.py
rm /root/nande/system/gesture.key
sync
umount /dev/nande










