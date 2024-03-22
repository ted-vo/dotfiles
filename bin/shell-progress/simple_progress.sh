#!/usr/bin/env bash

# show_progress
# show progress task in background
#
# Input:
#  $1 title
#  $! aka PID of the most recent executed background progress
#
# Output:
#   none
#
show_progress() {
	local white="\e[1;37m"
	local green="\e[1;32m"
	local red="\e[1;31m"
	local nc="\e[0m"

	local padding=5

	# calculate the column where spinner and status msg will be displayed
	column=$(($(tput cols) - ${#1} - padding))

	# display message and position the cursor in $column column
	# echo -en "$1"
	# printf "%${column}s"

	printf "%b" "$1"
	printf "%${column}s"

	pid=$2

	i=1
	sp='▘▀▝▐▗▄▖▌'
	delay=${SPINNER_DELAY:-0.15}
	while kill -0 $pid &>/dev/null; do
		echo -en "\b${sp:$((i++ % ${#sp})):1}"
		sleep "$delay"
	done

	wait $pid
	excode=$?

	printf "\b["
	if [[ $excode -eq 0 ]]; then
		printf "%b%b%b" "$green" "OK" "$nc"
	else
		printf "%b%b%b" "$red" "ERROR" "$nc"
	fi
	printf "]\n"

	sleep "$delay"
}
