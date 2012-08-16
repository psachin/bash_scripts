#!/bin/bash
# script to uncompress files

declare ZIP_FILES
declare RAR_FILES
declare UNZIP="unzip"
declare UNRAR="unrar x"

ZIP_FILES=$(ls | grep -i zip)
RAR_FILES=$(ls | grep -i rar)

# echo $ZIP_FILES
# echo $RAR_FILES


# make these two chunck of codes into a single funtion
if test ZIP_FILES
then
    # echo "zip file(s) present"
    for i in ${ZIP_FILES}
    do
    	$UNZIP $i
    done
else
    echo "no zip file(s) present"
fi


if test RAR_FILES
then
    # echo "rar file(s) present"
    for i in ${RAR_FILES}
    do
    	$UNRAR $i
    done
else
    echo "no rar file(s) present"
fi





    


