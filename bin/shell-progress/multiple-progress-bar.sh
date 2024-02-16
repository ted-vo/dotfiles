# Background tasks will no longer write directly to the console; instead,
#  they will write to temporary files which will be read periodically
#  by a special log printer task (which will display everything nicely.)
#
# Name of temporary files
STATUS_BASENAME="/tmp/~$$.status"
# Process IDs of backgrounded tasks; we record them so we can wait on them
#  specifically but not wait on the special log printer task
TASK_PIDS=""

do_something() {
	# First parameter must be a task ID starting at 0 incremented by 1
	TASK_ID=$1
	shift
	sleep 10
	# We write new status to status file (note we don't echo -n, we want that
	#  trailing newline)
	# Try to go through a temporary status file which we rename afterwards to
	#  avoid race conditions with the special log printer task
	echo "$1 of 5 Completed" >"${STATUS_BASENAME}.${TASK_ID}.tmp"
	mv "${STATUS_BASENAME}.${TASK_ID}.tmp" "${STATUS_BASENAME}.${TASK_ID}"
}

# Special log printer task
status_printer() {
	# First time in the loop is special insofar we don't have to
	#  scroll up to overwrite previous output.
	FIRST_TIME=1
	i=1
	sp=(⣾⣷⣯⣟⡿⢿⣻⣽)
	while true; do
		# If not first time, scroll up as many lines as we have
		#  regular background tasks to overwrite previous output.
		test $FIRST_TIME -eq 0 && for PID in $TASK_PIDS; do
			echo -ne '\033M' # scrol up one line using ANSI/VT100 cursor control sequences
		done
		FIRST_TIME=0
		TASK_ID=0
		for PID in $TASK_PIDS; do
			# If status file exists print first line
			test -f "${STATUS_BASENAME}.${TASK_ID}" && head -1 "${STATUS_BASENAME}.${TASK_ID}" || echo "${sp:$((i++ % ${#sp})):1} waiting..."
			TASK_ID=$(expr $TASK_ID + 1) # using expr for portability :)
		done
		test -f "${STATUS_BASENAME}.done" && return
		sleep 0.15 # seconds to wait between updates
	done
}

do_something 0 A &
TASK_PIDS="$TASK_PIDS $!"
do_something 1 B &
TASK_PIDS="$TASK_PIDS $!"
do_something 2 C &
TASK_PIDS="$TASK_PIDS $!"

status_printer &
PRINTER_PID=$!

# Wait for background tasks
wait $TASK_PIDS

# Stop special printer task instead of doing just
#  kill $PRINTER_PID >/dev/null
touch "${STATUS_BASENAME}.done"
wait $PRINTER_PID

# Cleanup
rm -f "${STATUS_BASENAME}."*
