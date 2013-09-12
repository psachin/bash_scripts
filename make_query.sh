#!/usr/bin/env bash
# Simple script to convert raw sqlite3 table to MySQL query.
# Use "infile.txt" for testing.

# Test usage: ./make_query.sh in_file.txt
# If the output is as expected, then redirect the o/p to a new file,
# ./make_query.sh out_file.txt

# type your SQL statement BELOW
INSERT_STATEMENT="INSERT INTO DHL_RFQ_MAIN VALUES"

if [ "$#" -lt "1" ];
then
    echo "Usage: $0 File_name"
    exit 0
elif [ ! -f "$1" ];
then
    echo "$1: does not exist."
    exit 0
fi

LINES=`cat $1`
for LINE in ${LINES}
do 
    LINE=`echo $LINE | sed 's/||//g' | sed "s/|/''/g" | sed "s/^/('/g" | \
	sed "s/\([^M]\)$/\1')/g" | cat -vet | sed 's/\^//g' | sed 's/M//g' | \
sed 's/\\$//g' | tr '[:lower:]' '[:upper:]'`
    echo "${INSERT_STATEMENT}${LINE}" 
done

# end of make_query.sh

