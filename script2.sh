#!/bin/bash 
# script.sh

declare PRESENT=`pwd`		# present dir for script
declare OUTPUT_EXT=".dat"	# extension of file submitted by students
declare STEP_DAT="step.dat"

echo $PRESENT

cd ../submissions/
declare DIR_NAME=$(ls -d */ | cut -f 1 -d /)
echo $DIR_NAME

for i in ${DIR_NAME[@]}
do
    # test of an array exist[optional]
    if test $i
    then
# 	echo $i
	cd $i &> /dev/null
# 	declare PRESENT_SUB_DIR=`pwd`		# present dir for script
 	pwd
	DAT_FILE=$(ls | grep -i "$OUTPUT_EXT")
 	echo $DAT_FILE
	mv -v $DAT_FILE $STEP_DAT 
	cp -v $STEP_DAT $PRESENT 
        # cat $PRESENT $STEP_DAT
	scilab $PRESENT -f firstorder_virtual.sce -nogui
        scilab $PRESENT -f secondorder_virtual.sce -nogui
	mkdir $PRESENT/$i
	cp -v $PRESENT/answers{1,2}.txt $PRESENT/$i

	cd ../ 
    fi 
done

