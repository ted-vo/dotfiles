#!/usr/bin/env bash

# Author: TedVo

# bar.sh
#
# Display an awesome 'progress bar' while running your long shell commands
#
# Do *NOT* call _spinner function directly.
# Use {start,stop}_progress_bar wrapper functions

# usage:
#   1. source this script in your's
#   2. start the spinner:
#       start_progress_bar [display-message-here]
#   3. run your command
#   4. stop the spinner:
#       stop_progress_bar [your command's exit status]
#
# Also see: test.sh

_bar() {
	sleep 10 &
	PID=$! #simulate a long process

	echo "THIS MAY TAKE A WHILE, PLEASE BE PATIENT WHILE ______ IS RUNNING..."
	printf "["
	# While process is running...
	while kill -0 $PID 2>/dev/null; do
		printf "▓"
		sleep 0.15
	done
	printf "] done!\n"
}
