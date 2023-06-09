#!/bin/bash

scriptPath=`realpath .`

/bin/bash -c $scriptPath/monitorServices.sh > $scriptPath/monitor_output.txt
exit_status=$?;
#echo "Exit: "$exit_status;
sed -i -e ':a' -e 'N;$!ba' -e  's/\n/"<br>\n/g' $scriptPath/monitor_output.txt
sed -i 's/\"//g' $scriptPath/monitor_output.txt
if [ $exit_status -eq 9 ];then
	/bin/python $scriptPath/mail_multiple.py
	if [ $? -eq 0 ];then
		echo "mail sent "$(date);
	fi
fi
