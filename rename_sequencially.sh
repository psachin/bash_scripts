#!/bin/bash

# rename arbitary filenames(with specific extensions) in sequencial
# order

# Usage: ./rename_sequencially.sh

FILES=`ls -1 *.png`
count=0
for FILE in $FILES
do
    count=$((count+1))	
    mv $FILE image${count}.png
done

