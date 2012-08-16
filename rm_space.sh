#!/bin/bash
# remove spaces filenames

for f in *
do
    new_name=$(echo $f | tr " " "_" | sed 's/_//g')
    mv -v "$f" "$new_name"
done


