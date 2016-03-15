#!/usr/bin/env bash
# Switch Git accounts..
# Usage:
# * source this script from ~/.bash*
# * To change user.email: gituser <whatever_case>

function gituser() {
    default_email="psachin@redhat.com"

    case "${1}" in
	"psachin")
	    email="psachin@redhat.com"
	    ;;
	"sacpatil")
	    email="sacpatil@redhat.com"
	    ;;
	"icl")
	    email="iclcoolster@gmail.com"
	    ;;
	*)
	    email="${default_email}"
    esac
    git config --global user.email "${email}"
    echo "user.email is now ${email}"
}

gituser
