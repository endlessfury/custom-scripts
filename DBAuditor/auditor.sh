#!/bin/bash
# Author: Wojciech Olszewski

. ~/.bash_profile

db_host="ip:port/sid"
arg_cnt=$#

if [ $# -ne 2 ]; then 
	echo "Wrong argument number, exiting..."; exit 
fi

mode=$1
value=$2

if [ "$mode" == "date" ]; then

sqlplus schema/password@$db_host << EOF  >/dev/null
set markup csv on DELIMITER , QUOTE OFF
set feedback off
spool ./output_changes_by_selected_date.part1.${$}.csv
sql_query_to_be_written
EOF

tail -n +2 ./output_changes_by_selected_date.part1.${$}.csv > ./output_changes_by_selected_date.part2.${$}.csv &&
head -n -1 ./output_changes_by_selected_date.part2.${$}.csv > ./output_changes_by_selected_date.csv && 
rm -f output*${$}.csv

# other modes defined the same
# elif [ "$mode" == "user" ]; then



fi

