#!/bin/bash

scriptPath=`realpath .`

/bin/bash -c $scriptPath/test_connectivity > $scriptPath/<output_file_name>
exit_status=$?;
#echo "Exit: "$exit_status;
sed -i -e ':a' -e 'N;$!ba' -e  's/\n/"<br>\n/g' $scriptPath/<output_file_name>
sed -i 's/\"//g' $scriptPath/<output_file_name>
if [ $exit_status -eq 9 ];then
echo "mail sent "$(date);
/bin/python $scriptPath/mail.py
fi
