#!/usr/bin/env bash

source "$(pwd)/spinner.sh"
source "$(pwd)/bar.sh"
source "$(pwd)/downloadbar.sh"

test_spiner() {
	# test success
	start_spinner 'sleeping for 2 secs...'
	sleep 2
	stop_spinner $?

	# test fail
	start_spinner 'copying non-existen files...'
	# use sleep to give spinner time to fork and run
	# because cp fails instantly
	sleep 1
	cp 'file1' 'file2' >/dev/null 2>&1
	stop_spinner $?
}

main() {
	find ./*.sh | awk 'NR>0' | while read -r line; do
		file=$(echo "$line" | sed 's/.\///g')
		if [[ $file = "test.sh" ]]; then
			continue
		fi
		echo "- $line" | sed 's/.\///g' | sed 's/.sh//'
	done

	read -rp "Chose style: " style
	case $style in
	spinner)
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
