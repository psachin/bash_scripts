#!/usr/bin/bash
# removing *.not-required files from all directories/sub-directories

FILENAME='dirty_file.txt'

find -type f -iname $FILENAME -exec rm -v {} \;

