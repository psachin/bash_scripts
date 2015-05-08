#!/bin/bash
# htm2sphinx.sh


function convert() {
    # ----
    # wil convert html to rst using `html2rest
    # <http://pypi.python.org/pypi/html2rest/>`_
    # ----
    FILE=$(find -type f -iname "*.htm")
    # echo $FILE

    for f in ${FILE[@]}
    do
        # echo $f
	RST=$(echo $f | sed 's/.htm/.rst/g')
        # echo $RST
	html2rest $f > $RST
    done
}


function reSt() {
    # ----
    # find .rst files(recursively) and edit it to the format
    # required by sphinx
    # ----
    DIR=$(find -maxdepth 1 -type d -iname "*" -not -iname ".")
    # echo $DIR

    for d in ${DIR[@]}
    do
	echo -e "$d"
	DIR_NAME=$(echo $d | sed 's$./$$g')
	echo "   ${DIR_NAME}" >> index
	echo "====" > ${DIR_NAME}.rst
	echo "$DIR_NAME" >> ${DIR_NAME}.rst
	echo "====" >> ${DIR_NAME}.rst

	cat content >> ${DIR_NAME}.rst

	find -type f -iname "*.rst" | \
    	    sed 's$^./$$g' | \
    	    sed 's/.rst//g' | \
    	    sed 's/^/   /g' | \
    	    grep "${DIR_NAME}" >> ${DIR_NAME}.rst

	cd $d
	RST_FILE=$(find -type f -iname "*.rst")
	for f in ${RST_FILE[@]}
	do
	    HEADING=$(echo $f | sed 's$./$$g' | sed 's/.rst//g')
            # echo $HEADING
	    sed -i '1i ====\n"'${HEADING}'"\n====\n' $f
	done
	cd ..
    done
}

# __init__
convert
reSt
