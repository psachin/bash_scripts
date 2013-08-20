#!/bin/bash

# find all .ipynb(ipython notebook) files in present directoryand
# convert nbformat from 3 to 2

# USAGE: ./nbformat_convert3to2.sh

FILE_LIST=$(find . -type f -iname "*.ipynb")

STRING='"nbformat": 3,'
REPLACE_STRING='"nbformat": 2,'
#echo $STRING
for FILE in ${FILE_LIST}
do
    # echo $FILE
    sed -i 's/'"${STRING}"'/'"${REPLACE_STRING}"'/g' $FILE
done

