#!/usr/bin/bash
# ==================================================
# task 2: scilab script for abhishek pawar

# -> There are three files in each folder namely,
# 1).net
# 2).net.out
# 3).out

# ->Go to file .out
# search for text starting with .tran
# If found copy that entire statement

# else
# search for text starting with .ac
# If found copy that entire statement

# else
# do nothing


# ->Now go to .net.out
# search for text .control
# Paste statement copied in previous step in after .control in this file
# (i.e)between .control and run.
# ==================================================


# ======================= variables ===========================


SRC='files'			# source folder
BCKP_EXT='.bak'			# backup extension for .net.out file 
TRAN='^\.tran'			# pattern
AC='^\.ac'			# pattern

# =================== variables end here ======================


# function to copy '.tran xxxx' line to *.net.out file
function find_dot_tran {

    # grep throught *.out file for line starting with '.tran xxxx' and
    # store the list of file in an array ${BUFFER_FILE[@]}
    BUFFER_FILE=$(find $SRC -type f -iname "*.out" \
	| xargs grep -e ${TRAN} | cut -d : -f -1)
    
    # Go through each of file in an array ${BUFFER_FILE[@]
    for FILES in ${BUFFER_FILE[@]}
    do
   	# echo $FILES
    	for FILE in ${FILES[@]}
    	do
	    # store the line '.tran xxxx' in a variable $LINE
	    LINE=$(cat $FILE | grep -e ${TRAN})

	    # remove '.' (dot) from the pattern '.tran'
	    LINE=$(echo $LINE | sed -e 's/\.//g') 

	    # replace .out extension with .net.out for every file
	    NET_OUT_FILE=$(echo $FILES | sed -e 's/'.out$'/'.net.out'/g')
	    
            # echo $LINE
	    # echo $NET_OUT_FILE
	    
	    # check if .net.out file exist
	    if [ -e $NET_OUT_FILE ];
	    then
		echo EXIST: $NET_OUT_FILE

		# check if backup file .net.out.bak was created
		if [ -e $NET_OUT_FILE${BCKP_EXT} ];
		then
		    echo $NET_OUT_FILE${BCKP_EXT} EXIST
		    
		    # if so, make a copy with .net.out extension
		    cp -v $NET_OUT_FILE${BCKP_EXT} $NET_OUT_FILE
		else
		    echo $NET_OUT_FILE${BCKP_EXT} NOT EXIST
		fi
		
		# append the pattern 'tran xxxx' just after the line
		# starting with .control in a file .net.out.
		
		# also make a backup copy with .bak as an extension
		sed -i${BCKP_EXT} -e '/^.control/a \'"$LINE"'' $NET_OUT_FILE

	    else
		echo NOT-EXIST: $NET_OUT_FILE
	    fi 
	done
    done
}

# function to copy '.ac xxxx' line to *.net.out file
function find_dot_ac {

    BUFFER_FILE=$(find $SRC -type f -iname "*.out" \
	| xargs grep -e ${AC} | cut -d : -f -1)
    
    for FILES in ${BUFFER_FILE[@]}
    do
   	# echo $FILES
    	for FILE in ${FILES[@]}
    	do
	    LINE=$(cat $FILE | grep -e ${AC})
	    LINE=$(echo $LINE | sed -e 's/\.//g') 
	    NET_OUT_FILE=$(echo $FILES | sed -e 's/'.out$'/'.net.out'/g')
	    # echo $LINE
	    # echo $NET_OUT_FILE
	    if [ -e $NET_OUT_FILE ];
	    then
		echo EXIST: $NET_OUT_FILE
		# sed -e '/^${LINE}/d' $NET_OUT_FILE 
		if [ -e $NET_OUT_FILE${BCKP_EXT} ];
		then
		    echo $NET_OUT_FILE${BCKP_EXT} EXIST
		    cp -v $NET_OUT_FILE${BCKP_EXT} $NET_OUT_FILE
		else
		    echo $NET_OUT_FILE${BCKP_EXT} NOT EXIST
		fi

		sed -i${BCKP_EXT} -e '/^.control/a \'"$LINE"'' $NET_OUT_FILE

	    else
		echo NOT-EXIST: $NET_OUT_FILE
	    fi 
	done
    done
}


# sample function to remove DOT from the pattern
function sample()
{
    PATTERN='.tran'
    echo $PATTERN | sed -e 's/\.//g'
}

# calling functions
find_dot_ac
find_dot_tran
#sample

# ======================= TODO ===========================

# Merge both functions in to one

# ========================================================