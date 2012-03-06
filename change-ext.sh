#!/usr/bin/bash
# change extension

FROM='txt'
TO='rtf'

FILE=$(find -type f -iname "*")
# echo $FILE

for f in $FILE
do
    mv -v $f $(echo $f | sed 's/.'$FROM'/.'$TO'/g')
done


