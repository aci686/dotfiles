#!/usr/bin/bash

#
#

declare -r ver='1.0.0'

plain() {
	(( QUIET )) && return
	local mesg=$1; shift
	printf "${BOLD}${mesg}${ALL_OFF}\n" "$@" >&1
}

msg() {
	(( QUIET )) && return
	local mesg=$1; shift
	printf "${GREEN}${ALL_OFF}${BOLD}${mesg}${ALL_OFF}\n" "$@" >&1
}

msg2() {
	(( QUIET )) && return
	local mesg=$1; shift
	printf "${BLUE}${ALL_OFF}${BOLD}${mesg}${ALL_OFF}\n" "$@" >&1
}

ask() {
	local mesg=$1; shift
	printf "${BLUE}$(gettext "QUESTION?")${ALL_OFF}${BOLD}${mesg}${ALL_OFF}" "$@" >&1
}

warning() {
	local mesg=$1; shift
	printf "${YELLOW}$(gettext "WARNING:")${ALL_OFF}${BOLD}${mesg}${ALL_OFF}\n" "$@" >&2
}

error() {
	local mesg=$1; shift
	printf "${RED} $(gettext "ERROR:")${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}

# check if messages are to be printed using color
unset ALL_OFF BOLD BLUE GREEN RED YELLOW
if [[ -t 2 && ! $USE_COLOR = "n" ]]; then
	# prefer terminal safe colored and bold text when tput is supported
	if tput setaf 0 &>/dev/null; then
		ALL_OFF="$(tput sgr0)"
		BOLD="$(tput bold)"
		BLUE="${BOLD}$(tput setaf 4)"
		GREEN="${BOLD}$(tput setaf 2)"
		RED="${BOLD}$(tput setaf 1)"
		YELLOW="${BOLD}$(tput setaf 3)"
	else
		ALL_OFF="\e[1;0m"
		BOLD="\e[1;1m"
		BLUE="${BOLD}\e[1;34m"
		GREEN="${BOLD}\e[1;32m"
		RED="${BOLD}\e[1;31m"
		YELLOW="${BOLD}\e[1;33m"
	fi
fi
readonly ALL_OFF BOLD BLUE GREEN RED YELLOW


if (( $# > 0 )); then
	echo "Check_Updates v${ver}"
	echo
	echo "Safely gets the number of pending updates on any Debian-like system"
	echo
	echo "Usage: check_updates" 
	echo
	exit 0
fi

if ! result=$(apt-get -s upgrade | grep upgraded | awk '{print $1}' | awk '/^[0-9]$/' 2> /dev/null); then
    error 'Cannot get updates'
else
    msg $result' Updates available'
fi

exit 0
