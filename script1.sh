#!/usr/bin/bash 
# script3-1.sh


# ---------- GLOBAL VARIABLES ----------
# here you can change the variable values
DATE=$(date)
declare OUTPUT_EXT=".dat"	# extension of file submitted by students
declare LOG_EXT=".log"		# extension for server log files

declare LOGS="logs/"		# directory for all .log file
declare DAT="dat/"		# directory for all .dat file

declare PRESENT=`pwd`		# present dir for script
declare RESULT="results"	# results file
declare ERROR_LOGS="error.log"	# error file

# ---------- GLOBAL VARIABLES ENDS HERE ----------


# ---------- RESULTS ----------
# if previous 'results' file exist, then notify user
# if 'y' then overwrite the old 'result' file with new one
# if 'n' then make backup copy with the name 'results.bak'

if [ -f "$RESULT" ]; then
    read -p "$RESULT already exist !, do you want to overwrite? (y/n) : " ANS
    case $ANS in
	[Yy] ) echo $DATE > $PRESENT/$RESULT
	    echo $DATE > $PRESENT/$ERROR_LOGS
	    ;;
	[Nn] ) mv -v $PRESENT/$RESULT{,.bak} &> /dev/null
	    echo $DATE > $PRESENT/$RESULT
	    ;;
	*) echo "Please answer y/n."
	    exit 0
	    ;; 
    esac
else
    echo $DATE > $PRESENT/$RESULT
fi 

# ---------- RESULT SECTION ENDS HERE ----------


# enter 'dat' directory
cd $DAT &> /dev/null
# all sub-directories within 'dat' are list as an arrays in DIR_NAME
declare DIR_NAME=$(ls -d */ | cut -f 1 -d /)
# echo $DIR_NAME


# loop through each sub-directory inside $DAT
for i in ${DIR_NAME[@]}
do
    # test of an array exist[optional]
    if test $i
    then
        # echo $i
	# change directory 
	cd $i &> /dev/null

	# search for .dat file
	SUBMITTED_FILE=$(ls | grep -i "$OUTPUT_EXT")
        # echo $SUBMITTED_FILE

	# if .dat file not present, log error ELSE scan for same filename in 'logs/' dir
	if [ ! -n "$SUBMITTED_FILE" ] ; then 
	    echo "$OUTPUT_EXT file missing in dir : $i" >> $PRESENT/$ERROR_LOGS
	else
	    FOUND=$(find $PRESENT/$LOGS -type d -iname $i)
	    if [ ! -n "$FOUND" ]; then
		echo "Directory $i not present in $LOGS dir" >> $PRESENT/$ERROR_LOGS 
	    else 
		# loop through each sub-directory within logs/
		for j in $FOUND
		do
		    cd $j &> /dev/null
		    LOG_FILE_NAME=$(ls)
                    # echo $LOG_FILE_NAME
		    for k in $LOG_FILE_NAME
		    do 
			SRC=$PRESENT/$DAT/$i/$SUBMITTED_FILE
			DEST=$j/$k
                        # echo $SRC
                        # echo $DEST
                        # echo "$SUBMITTED_FILE from $i compared with $k in $j"

			# if similar dir present, compare .dat file with every file in the sub-directory
			cmp -s $SRC $DEST &> /dev/null
			if [ $? -eq 1 ]; then
			    echo "" &> /dev/null
			else
			    # if file matches, create results
			    echo "$k matches $SUBMITTED_FILE, student/id: $i" >> $PRESENT/$RESULT
			fi
		    done
		    cd - &> /dev/null
		done
	    fi 
	fi
	unset SUBMITTED_FILE
    fi
    cd ../
done

