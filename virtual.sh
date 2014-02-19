#!/usr/bin/env bash
# Set virtual environment

# Usage:
#
# Added this file to your .bashrc or any local rc
# $ source /path/to/virtual.sh
#
# Now you can 'activate' the virtual environment by typing
# $ setv <YOUR VIRTUAL ENVIRONMENT NAME>
#
# For example:
# $ setv rango
#
# To deactivate type:
# $ deactivate
#


# Path to your virtual environment directories
VIRTUAL_DIR_PATH="/home/sachin/virtualenvs/"

function setv() {
    # Check if the virtual directory exists in PATH
    if [ -d ${VIRTUAL_DIR_PATH}${1} ];
    then
	# Activate the virtual environment
	source ${VIRTUAL_DIR_PATH}${1}/bin/activate
    else
	# Else throw an error message
	echo "Sorry, you don't have any virtual environment with that name"
    fi
}





