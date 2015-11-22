#!/usr/bin/env bash
# Script to compile the kernel
# Usage: bash build_my_kernel.sh
# and follow the instructions

# ---- You need to configure these variables ----
# Default location of the (working)config file.
DEFAULT_CONFIG_FILE=$(pwd)/config-bleeding-edge
# Partition where root filesystem resides.
ROOTFS_DEV="sda2"
# -----------------------------------------------

# TODO: When CONFIG_LOCALVERSION_AUTO=y, the kernel module dir:
# /lib/modules/KERNEL_VERSION-(EXTRA_STRING) has extra string.
# mkinitrd requires this KERNEL_VERSION-(EXTRA_STRING) to create
# initrd compressed file.
# DONE: Defined KERNEL_RELEASE
# Note: `make kernelrelease` requires .config
KERNEL_VERSION=$(make kernelversion)
DATE_TIME=$(date +"%d-%b-%Y_%T")

KERNEL_SRC=$(pwd)
BUILD_PATH=$(dirname "$KERNEL_SRC")/build-$KERNEL_VERSION

echo $KERNEL_SRC
echo $BUILD_PATH

if [ -d "$KERNEL_SRC" ];
then
    echo "Kernel source directory: OK"
else
    echo "$KERNEL_SRC does not exist"
    exit 1
fi

if [ -d "$BUILD_PATH" ];
then
    echo "Build directory: OK"
else
    echo "$BUILD_PATH does not exist"
    echo "Creating build directory..$BUILD_PATH"
    mkdir -p $BUILD_PATH
fi

echo "Cleaning kernel source.."
pushd $KERNEL_SRC
if [ -f .config ];
then
    mv .config config-current
    CONFIG_TRUE=1
else
    CONFIG_TRUE=0
fi

make distclean; make mrproper; make clean
echo "Copy reference config file $DEFAULT_CONFIG_FILE to start with.."
if [ -f $DEFAULT_CONFIG_FILE ];
then
    # TODO: While
    read -p "Do you want to copy default config file? (y/n)" ANS
    case $ANS in
	[Yy] ) cp -v $DEFAULT_CONFIG_FILE .config
	       ;;
	[Nn] ) echo "Will use default config file available'"
	       ;;
        *) echo "Please answer y/n."
	      exit 1
	      ;;
    esac
fi

if [ ! -f .config ];
then
    if [ "${CONFIG_TRUE}" -eq 1 ];
    then
	mv config-current .config
    else
	echo "You do not have config file, please run 'make localmodconfig'"
	echo "and start this script again"
	exit 1
    fi
fi

# want to configure?
# TODO: While
read -p "Do you want to configure the kernel? (y/n/q)" ANS
case $ANS in
    [Yy] ) make menuconfig
	   echo "Done configuring kernel.."
	   ;;
    [Nn] ) echo "Going with existing configuration.."
	   ;;
    [Qq] ) echo "Exit."
	   exit 0
	   ;;
	*) echo "Please answer y/n/q."
	   exit 1
	   ;;
esac

echo "Cleaning build directory.."
pushd $BUILD_PATH
rm -rf *; rm -rf .*

popd
# TODO: Backup this configuration file? to configs/
# custom name to config file or date-time stamp?
# TODO: Prompt to backup configuration file
# TODO: with custom name
mv -v .config $BUILD_PATH
make -j4 O=$BUILD_PATH
make modules O=$BUILD_PATH

pushd $KERNEL_SRC
echo "Installing kernel modules.."
make modules_install O=$BUILD_PATH

KERNEL_RELEASE=$(cat $BUILD_PATH/include/config/kernel.release 2> /dev/null)

echo "Creating initrd.."
mkinitrd -c -k $KERNEL_RELEASE -f ext4 -r /dev/${ROOTFS_DEV} -m ext4 -u -o /boot/initrd-$KERNEL_RELEASE.gz
echo "Installing kernel.."
make install O=$BUILD_PATH

if [ -f /boot/vmlinuz ];
then
    echo "Renaming kernel binary by release version"
    mv -v /boot/vmlinuz /boot/vmlinuz-$KERNEL_RELEASE
else
    echo "ERR: /boot/vmlinuz, not found, kernel installation must have failed!"
fi

# Check the existance
if [ -f /boot/vmlinuz-$KERNEL_RELEASE ];
then
    echo "Kernel installed sucessfully"
    echo "Check entry in /etc/lilo.conf and run 'lilo'"
else
    echo "ERR: Something went wrong!"
    echo "ERR: I don't find vmlinuz with kernel version you have compiled"
fi
