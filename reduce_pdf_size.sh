#!/usr/bin/env bash
# Reduce PDF file size.
# Requires: GhostScript(gs)
#
# Usage:
# bash reduce_pdf_size.sh
#
read -p "Input PDF filename: " original_file

if [ -e $original_file ];
then
    file $original_file | grep -i "pdf"
    if [ $? -eq 0 ];
    then
	read -p "Output PDF filename(with .pdf as extension): " new_file
	gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -sOutputFile=$new_file $original_file
    else
	echo "Error: File should be in PDF format"
	exit 2
    fi
else
    echo "No file with the name: $original_file"
    exit 1
fi
exit 0
