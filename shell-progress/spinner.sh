#!/usr/bin/env bash

# Author: Tasos Latsas
# Update: TedVo

# spinner.sh
#
# Display an awesome 'spinner' while running your long shell commands
#
# Do *NOT* call _spinner function directly.
# Use {start,stop}_spinner wrapper functions

# usage:
#   1. source this script in your's
#   2. start the spinner:
#       start_spinner [display-message-here]
#   3. run your command
#   4. stop the spinner:
#       stop_spinner [your command's exit status]
#
# Also see: test.sh

_spinner() {
	# $1 start/stop
	#
	# on start: $2 display message
	# on stop : $2 process exit status
	#           $3 spinner function pid (supplied from stop_spinner)

	local on_success="DONE"
	local on_fail="FAIL"
	# local white="\e[1;37m"
	local green="\e[1;32m"
	local red="\e[1;31m"
	local nc="\e[0m"

	case $1 in
	start)
		local padding=120

		# calculate the column where spinner and status msg will be displayed
		column=$(($(tput cols) - ${#2} - padding))

		# display message and position the cursor in $column column
		printf "%b" "$2"
		printf "%${column}s"

		# start spinner
		i=1
		# Charactor: https://en.wikipedia.org/wiki/Block_Elements#Character_table
		# sp='\|/-'
		sp='▘▀▝▐▗▄▖▌'
		delay=${SPINNER_DELAY:-0.15}

		while :; do
			printf "\b%b" "${sp:$((i++ % ${#sp})):1}"
			sleep "$delay"
		done
		;;
	stop)
		if [[ -z ${3} ]]; then
			printf "spinner is not running..\n"
			exit 1
		fi

		kill "$3" >/dev/null 2>&1

		# inform the user uppon success or failure
		printf "\b["
		if [[ $2 -eq 0 ]]; then
			printf "%b%b%b" "$green" "$on_success" "$nc"
		else
			printf "%b%b%b" "$red" "$on_fail" "$nc"
		fi
		printf "]\n"
		;;
	*)
		printf "invalid argument, try {start/stop}\n"
		exit 1
		;;
	esac
}

start_spinner() {
	# $1 : msg to display
	_spinner "start" "$1" &
	# set global spinner pid
	_sp_pid=$!
	disown
}

stop_spinner() {
	# $1 : command exit status
	_spinner "stop" "$1" "$_sp_pid"
	unset _sp_pid
}

exit_script() {
	echo ""
	echo "Exit from SIGINT SIGTERM"
	trap - SIGINT SIGTERM # clear the trap
	kill -- -$$           # Sends SIGTERM to child/sub processes
}

trap exit_script SIGINT SIGTERM
