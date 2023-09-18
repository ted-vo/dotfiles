#!/usr/bin/env bash

# show_progress
# show progress task in background
#
# Input:
#  $! aka PID of the most recent executed background progress
#
# Output:
#   none
#
show_progress() {
	sp='▘▀▝▐▗▄▖▌'
	delay=${SPINNER_DELAY:-0.15}
	while ps | grep $1 &>/dev/null; do
		printf "\b%b" "${sp:$((i++ % ${#sp})):1}"
		sleep "$delay"
	done
	echo -en "Done!\n"
	sleep "$delay"
}
