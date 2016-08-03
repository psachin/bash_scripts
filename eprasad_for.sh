#!/usr/bin/env bash
# Use case: Copy all files with the name "evm.log" to common location
# renaming them in incremental order

# Change value accordingly
FILE_NAME="evm.log"
COPY_FROM="~/tmp"
COPY_TO="~/logs"

## Example demonstration `find` followed by `grep`
# for i in $(find . | grep evm.log | grep -v gz | grep -v rhev) ;
# do
# 	n=$((n+1))
# 	cp $i evm/evm$n.log
# done

for i in $(find ${COPY_FROM} -iname "evm.log");
do
	n=$((n+1))
	cp -v $i ${COPY_TO}/evm${n}.log
done
