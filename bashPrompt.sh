#!/usr/bin/env bash
# ref: https://gist.github.com/31631

function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

function current_date() {
    # date format
    date +%a-%b-%d-%Y,%k:%M:%S
}

function list_dirs() {
    # list directories.
    DIRS=$(ls -d */ 2> /dev/null) # only stderr to /dev/null
    if [[ $DIRS ]];
    then
	ls -d */ | wc -l
    else
	echo "0"
    fi
}

function list_files() {
    # list files.
    FILES=$(ls -l | grep ^- 2> /dev/null)
    if [[ $FILES ]];
    then
	ls -l | grep ^- | wc -l
    else
	echo "0"
    fi
}

