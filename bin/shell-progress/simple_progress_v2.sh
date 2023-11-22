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
	local blue='\e[1;34m'
	local red="\e[1;31m"
	local nc="\e[0m"

	msg=$1
	pid=$2

	echo ""
	echo -en "\r${blue}∙ $msg... "

	i=1
	# sp='▘▀▝▐▗▄▖▌'
	sp='≐≑≓≕≒≔'
	delay=${SPINNER_DELAY:-0.15}
	while ps | grep $pid &>/dev/null; do
		local step=$((i++ % ${#sp}))
		echo -en "\r${sp:${step}:1} $msg... "
		sleep "$delay"
	done

	wait $pid
	excode=$?

	if [[ $excode -eq 0 ]]; then
		echo -en "\r ${green}✔️ $msg... OK!"
	else
		echo -en "\r ${red}✖️ $msg... Error!"
	fi

	sleep "$delay"
}

sleep 10 &
show_progress "Hello" $!

cp 'file1' 'file2' &>/dev/null 2>$1 &
show_progress "Coping" $!

echo ""
