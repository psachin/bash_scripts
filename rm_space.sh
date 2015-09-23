#!/bin/bash
# Remove spaces filenames


for f in *
do
    new_name=$(echo "$f" | tr " " "_" | sed 's/_//g') # remote SPACE

    if [ "${f}" != "${new_name}" ]; # should not unnecessarily rename
				    # files with same names
    then
    	if [ "./${f}" == "$0" ]; # should not try rename itself
    	then
    	    echo ""
    	else
    	    mv -v "$f" "$new_name"
    	fi
    fi
done
