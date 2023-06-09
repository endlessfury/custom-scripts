#!/bin/bash

WO_SUBSYSTEM="<process_name>"
WO_PID="$(ps -aux | grep $WO_SUBSYSTEM | grep -v grep | awk '{print $2}')

while true; do
	echo "$(date) - Number of open files for PID: $WO_PID is: $(ls -l /proc/$WO_PID/fd | wc -l)";
	sleep 60
done;