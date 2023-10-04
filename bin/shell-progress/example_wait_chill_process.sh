#!/bin/bash

# start 3 child processes concurrently, and store each pid into array PIDS[].
process=(a.sh b.sh c.sh)
for app in ${process[@]}; do
	./${app} &
	PIDS+=($!)
done

# wait for all processes to finish, and store each process's exit code into array STATUS[].
for pid in ${PIDS[@]}; do
	echo "pid=${pid}"
	wait ${pid}
	STATUS+=($?)
done

# after all processed finish, check their exit codes in STATUS[].
i=0
for st in ${STATUS[@]}; do
	if [[ ${st} -ne 0 ]]; then
		echo "$i failed"
	else
		echo "$i finish"
	fi
	((i += 1))
done
