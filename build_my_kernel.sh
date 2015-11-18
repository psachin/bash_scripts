#!/usr/bin/env bash

# TODO: This can be removed if relative paths are used.
HOME=/home/sachin

DEFAULT_CONFIG_FILE=$HOME/kernel/configs/slackware-lenovo-laptop-config-3.19.0
ROOTFS_DEV="sda2"

# TODO: When CONFIG_LOCALVERSION_AUTO=y, the kernel module dir:
# /lib/modules/KERNEL_VERSION-(EXTRA_STRING) has some extra string.
# mkinitrd requires this KERNEL_VERSION-(EXTRA_STRING) to create
# initrd
KERNEL_VERSION=$(make kernelversion)
DATE_TIME=$(date +"%d-%b-%Y_%T")

# TODO: This should be relative, use $(pwd)
KERNEL_SRC=$HOME/kernel/linux-$KERNEL_VERSION
# TODO: ../
BUILD_PATH=$HOME/kernel/build-$KERNEL_VERSION

echo $KERNEL_SRC
echo $BUILD_PATH

if [ -d "$KERNEL_SRC" ];
then
    echo "Good to go"
else
    echo "$KERNEL_SRC does not exist"
    exit 1
fi

if [ -d "$BUILD_PATH" ];
then
    echo "Good to go"
else
    echo "$BUILD_PATH does not exist"
    echo "Creating build directory..$BUILD_PATH"
    mkdir -p $BUILD_PATH
fi

echo "Cleaning kernel source.."
pushd $KERNEL_SRC
make distclean; make mrproper; make clean
echo "Copy reference config file $DEFAULT_CONFIG_FILE to start with.."
if [ -f $DEFAULT_CONFIG_FILE ];
then
    cp -v $DEFAULT_CONFIG_FILE .config
else
    echo "ERR: Config file $DEFAULT_CONFIG_FILE does not exist!"
fi

# want to configure?
read -p "Do you want to configure the kernel? or go with existing configuration? (y/n)" ANS
case $ANS in
    [Yy] ) make menuconfig
	   echo "Done configuring kernel.."
	   ;;
    [Nn] ) echo "Going with existing configuration.."
	   ;;
	*) echo "Please answer y/n."
	   exit 0
	   ;;
esac

echo "Cleaning build directory.."
pushd $BUILD_PATH
rm -rf *; rm -rf .*

popd
# TODO: Backup this configuration file? to configs/
# custom name to config file or date-time stamp?
# TODO: Prompt to backup configuration file
# TODO: .. with custom name
mv -v .config $BUILD_PATH
make -j4 O=$BUILD_PATH
make modules O=$BUILD_PATH

pushd $KERNEL_SRC
# echo "Installing kernel modules.."
make modules_install O=$BUILD_PATH

echo "Creating initrd.."
mkinitrd -c -k $KERNEL_VERSION -f ext4 -r /dev/${ROOTFS_DEV} -m ext4 -u -o /boot/initrd-$KERNEL_VERSION.gz
echo "Installing kernel.."
make install O=$BUILD_PATH
echo "Renaming kernel binary by version"
mv /boot/vmlinuz /boot/vmlinuz-$KERNEL_VERSION

if [ -f /boot/vmlinuz-$KERNEL_VERSION ];
then
    echo "Kernel installed sucessfully"
else
    echo "ERR: Something went wrong!"
    echo "ERR: I don't find vmlinuz with kernel version you have compiled"
fi
