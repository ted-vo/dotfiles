#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[-1]}")" &>/dev/null && pwd)

source "$SCRIPT_DIR/bar.sh"
source "$SCRIPT_DIR/downloadbar.sh"
source "$SCRIPT_DIR/simple_progress.sh"

test_spiner() {
	# test success
	sleep 2 &
	show_progress 'sleeping for 2 secs...' $!

	# test fail
	# use sleep to give spinner time to fork and run
	# because cp fails instantly
	cp 'file1' 'file2' &>/dev/null 2>$1 &
	show_progress 'copying non-existen files...' $!
}

main() {
	find ./*.sh | awk 'NR>0' | while read -r line; do
		file=$(echo "$line" | sed 's/.\///g')
		if [[ $file = "test.sh" ]] || [[ $file = "test-2.sh" ]]; then
			continue
		fi
		echo "- $line" | sed 's/.\///g' | sed 's/.sh//'
	done

	read -rp "Chose style: " style
	case $style in
	simple_progress)
		test_spiner
		exit
		;;
	bar)
		_bar
		exit
		;;
	downloadbar)
		# download_bar_example
		progress_bar 60
		exit
		;;
	esac
}

main
