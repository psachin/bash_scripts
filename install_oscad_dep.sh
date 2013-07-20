#!/bin/bash
# Check and install Oscad dependencies

# This code snippet is a part of installOSCAD.sh file

# Usage: 
# 1. Place all the .deb files in the same directory where this script
#    is going to be there.
# 2. Run this script using the command:
#    bash install_oscad_dep.sh


# get list of all installed packages
DPKG_INSTALL=$(dpkg --get-selections | grep -w 'install' | awk '{print $1}')

# generate list of all .deb files present in THIS directory
OSCAD_DEP=$(ls -1 *.deb | cut -d '_' -f 1)

# check against the list of installed packages
for dep in ${OSCAD_DEP}
do
    if [[ "${DPKG_INSTALL}" =~ "${dep}" ]] ; 
    then
	# if the package is installed, don't do anything(just echo)
	echo "package ${dep} INSTALLED"
    else
	# else install the relevant DEB file
	echo "package ${dep} NOT installed"
	sudo dpkg -i ${dep}*.deb
    fi
done

