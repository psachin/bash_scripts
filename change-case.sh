#!/usr/bin/bash
# turns all file_names to lowerCase recursively

for i in $(find . -type f -iname "*" -not -iname "convert.sh*" )
do mv -v "$i" "$(echo $i | tr a-z A-Z)" &> /dev/null
done


