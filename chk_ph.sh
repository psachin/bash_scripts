#!/bin/bash

ZIP_FILE="Kturtle.zip"
rm -vf online_pc.txt
rm -vf offline_pc.txt

if [ -f ${ZIP_FILE} ];
then
    echo "extracting ${ZIP_FILE} .. please wait"
    unzip $ZIP_FILE
else
    echo "file ${ZIP_FILE} does not exist"
fi

for i in 10.112.16.{01..50}
do 
    ping -c 1 $i 
    if [ $? -eq 0 ];
	then
	echo "$i is LIVE" >> online_pc.txt
	IP=$(echo ${i} | cut -f 4 -d .)
	echo "$i $IP"
	echo "password is same as username i.e physics${IP}"
	echo "else try: student123 "
	scp -r Kturtle physics${IP}@${i}:~/Desktop/
    else
	echo "$i" is DOWN >> offline_pc.txt
    fi
done

