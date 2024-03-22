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
anim_classic=(0.25 '-' "\\" '|' '/')
anim_box=(0.2 ┤ ┴ ├ ┬)
anim_bubble=(0.6 · o O O o ·)
anim_breathe=(0.9 '  ()  ' ' (  ) ' '(    )' ' (  ) ')
anim_growing_dots=(0.5 '.  ' '.. ' '...' '.. ' '.  ' '   ')
anim_equas=(0.25 ≐ ≑ ≓ ≕ ≒ ≔)
anim_semi_circle=(0.25 ◐ ◓ ◑ ◒)
anim_braille_whitespace=(0.15 ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷)

white="\e[1;37m"
green="\e[1;32m"
blue='\e[1;34m'
red="\e[1;31m"
nc="\e[0m"

play_animation() {
	local msg=$1
	local color=$2
	local frames=($3)
	local delay=${frames[0]}
	unset "frames[0]"

	# echo "---"
	# echo "msg=$msg"
	# echo "color=$color"
	# echo "frames=${frames[@]}"
	# echo "delay=$delay"
	# echo "pid=$pid"
	# echo "---"

	echo ""
	echo -en "\r${color}∙ $msg... "
	while kill -0 $pid &>/dev/null; do
		for frame in "${frames[@]}"; do
			echo -en "\r$color $frame $msg..."
			sleep $delay
		done
	done
}

show_progress() {
	load_params ${@}

	anim=${anim:=${anim_braille_whitespace[@]}}
	play_animation "$msg" "${blue}" "${anim[@]}"

	# animation done
	wait $pid
	excode=$?

	if [[ $excode -eq 0 ]]; then
		echo -en "\r ${green}✔️ $msg... OK!"
	else
		echo -en "\r ${red}✖️ $msg... Error!"
	fi
	echo -en "${nc}"
}

load_anim() {
	anim=$1
	case "$1" in
	1)
		anim=${anim_classic[@]}
		;;
	2)
		anim=${anim_box[@]}
		;;
	3)
		anim=${anim_bubble[@]}
		;;
	4)
		anim=${anim_breathe[@]}
		;;
	5)
		anim=${anim_growing_dots[@]}
		;;
	6)
		anim=${anim_equas[@]}
		;;
	7)
		anim=${anim_semi_circle[@]}
		;;
	*)
		anim=${anim_braille_whitespace[@]}
		;;
	esac
}

load_params() {
	while [[ $# > 0 ]]; do
		case $1 in
		-h | --help)
			global_help
			;;
		-pid | --process-id)
			shift
			pid=$1
			shift
			;;
		-m | --message)
			shift
			msg=$1
			while [[ $# > 0 && "$2" != "-"* ]]; do
				shift
				msg="$msg $1"
			done
			shift
			;;
		-a | --anim)
			shift
			load_anim $1
			shift
			;;
		*)
			echo ""
			echo "Run 'show_progress -h|--help' for usage."
			exit 1
			;;
		esac
	done
}

test_anim() {
	sleep 10 &
	show_progress -m "Hello world" -pid $! -a 7

	cp 'file1' 'file2' &>/dev/null 2>$1 &
	show_progress -m "Coping files" -pid $!

	echo ""
}

test_anim
