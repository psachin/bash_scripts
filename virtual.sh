#!/usr/bin/env bash
# Set virtual environment

# Configure:
# Set the `VIRTUAL_DIR_PATH` variable value to valid PATH to your virtual envs
#
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
# To list all your virtual environments:
# $ setv -l
#
# To deactivate type:
# $ deactivate
#

# Path to your virtual environment directories
VIRTUAL_DIR_PATH="/home/sachin/virtualenvs/"

function setv() {
    if [ ${1} == "-l" ];
    then
       echo "List of virtual environments you have under ${VIRTUAL_DIR_PATH}:"
       echo " "
       LIST_OF_VIRTUALENVS=$(ls -1 ${VIRTUAL_DIR_PATH})
       for virt in ${LIST_OF_VIRTUALENVS}
       do
	   echo ${virt}
       done
       # Check if the virtual directory exists in PATH
    elif [ -d ${VIRTUAL_DIR_PATH}${1} ];
    then
	# Activate the virtual environment
	source ${VIRTUAL_DIR_PATH}${1}/bin/activate
    else
	# Else throw an error message
	echo "Sorry, you don't have any virtual environment with that name"
	echo "To list all virtual environments, type:"
	echo "setv -l"
    fi
}
