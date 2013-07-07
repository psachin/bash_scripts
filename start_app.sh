#!/bin/bash
# startup script for android project

# first arg
# rm, for deleting bin/ and gen/
# update, to update project

# vars
PKG_NAME="com.vogella.android.userinterface.undo"
APK_NAME="MainActivity-debug.apk"

# remove /bin and gen/ if first argument passed is 'rm'
function rmbingen() {
    if [ "$1" == "rm" ];
    then 
        # uncomment below 2 line to remove bin/ and gen/
	if [ -d "bin/" || -d "gen/" ];
	then
	    rm -rvf bin/
	    rm -rvf gen/
	else
	    echo "No bin/ or gen/ found!"
	fi
    else
	echo "leaving bin/ and gen/ as it is"
    fi    
}
# execute function rmbingen
rmbingen $1

# remote old bin/ and gen/ and update the project
if [ "$1" == "update" ];
then
    echo "creating ant project.."
    rmbingen rm
    # this will update a repo for `ant` to build an apk
    android update project --path . --target android-17 --subprojects
else
    echo "not updating the project"
fi

# uninstall apk
adb uninstall ${PKG_NAME}

# build apk in debug mode
echo "Building APK.."
ant debug

if [ -f /bin/${APK_NAME} ];
then
    # install apk
    echo "Installing APK.."
    adb install bin/${APK_NAME}

    # Start Main activity
    adb shell am start -a android.intent.action.MAIN -n ${PKG_NAME}/.MainActivity
else
    echo "APK not found!!"
    exit 1
fi

