#!/usr/bin/env bash

./adb reboot bootloader
./fastboot flash boot boot.img

echo "Do you want to keep your user data ? (Some users has problems in first reboot, if you have, please reflash and select not to keep the data)"
echo "(Type 1, 2, or 3)"
select ynq in "Yes" "No" "Quit"; do
case $ynq in
    Yes) echo "User data will be preserved during flash."
	break;;
    No) echo "User data will be erased during flash.";
	./fastboot flash userdata userdata.img;
	break;;
    Quit) echo "Bye."
	break;;
esac
done

./fastboot flash system system.img
./fastboot flash recovery recovery.img
./fastboot erase cache
./fastboot reboot




