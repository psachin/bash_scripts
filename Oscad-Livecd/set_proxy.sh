#!/bin/bash

export http_proxy="http://10.118.248.42:3128/"
export https_proxy="http://10.118.248.42:3128/"
export ftp_proxy="http://10.118.248.42:3128/"
export socks_proxy="http://10.118.248.42:3128/"

mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

export HOME=/root
export LC_ALL=C

PS1="chroot:\w # "
