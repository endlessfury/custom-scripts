#!/bin/bash

# version 3

SQLFILE=$1;
OUTPUT_FILENAME=$2;
DEST=$4;
QUOTE=$5;
NEW_DELIMITER=$3
echo $QUOTE;
#DATE=`date +%Y%m%d_%H%M%S`;

SCRIPTS_LOC=<path_to_script>/NRMReportsExecutor
REPORT_LOC=<path_to_script>/NRMReportsExecutor

. $HOME/.bash_profile

sqlplus schema/password@NRM << EOF  >/dev/null

set markup csv on DELIMITER < QUOTE OFF
 
spool $REPORT_LOC/${OUTPUT_FILENAME}_${$}.part1

@$SCRIPTS_LOC/SQLs/$SQLFILE

exit
EOF

if [ -f "$SCRIPTS_LOC/SQLs/$SQLFILE" ]; then
    tail -n +4 $REPORT_LOC/${OUTPUT_FILENAME}_${$}.part1 > $REPORT_LOC/${OUTPUT_FILENAME}_${$}.part2 &&
	head -n -5 $REPORT_LOC/${OUTPUT_FILENAME}_${$}.part2 > $REPORT_LOC/${OUTPUT_FILENAME}_${$}.part3 &&
	if [ "$QUOTE" == "OFF" ]; then
		sed "s|<|$NEW_DELIMITER|g" $REPORT_LOC/${OUTPUT_FILENAME}_${$}.part3 > $REPORT_LOC/$OUTPUT_FILENAME.csv 
	elif [ -z "$QUOTE" ]; then
		sed "s/</\"<\"/g" $REPORT_LOC/${OUTPUT_FILENAME}_${$}.part3 | sed "s/\"<\"/\"$NEW_DELIMITER\"/g"> $REPORT_LOC/${OUTPUT_FILENAME}_${$}.part4 &&
		sed 's/^/"/g' $REPORT_LOC/${OUTPUT_FILENAME}_${$}.part4 > $REPORT_LOC/${OUTPUT_FILENAME}_${$}.part5 &&
		sed 's/$/"/g' $REPORT_LOC/${OUTPUT_FILENAME}_${$}.part5 > $REPORT_LOC/$OUTPUT_FILENAME.csv 
	fi &&
	scp -q $REPORT_LOC/$OUTPUT_FILENAME.csv <report_server_user>@<report_server_ip>:<report_server_report_mainpath>/$DEST &&
	DATE=`date +%Y%m%d_%H%M%S`;
	echo -e "$(wc -l $REPORT_LOC/$OUTPUT_FILENAME.csv | awk '{ print $1 }')\t$(du -s $REPORT_LOC/$OUTPUT_FILENAME.csv  | awk '{ print $1 }')\t<report_server_report_mainpath>/$DEST/$OUTPUT_FILENAME.csv\t$DATE" &&
	rm $REPORT_LOC/$OUTPUT_FILENAME.csv # &&
	#echo "Rows: $(wc -l $REPORT_LOC/$OUTPUT_FILENAME.csv | awk '{ print $1 }')" &&
	#echo "Size: $(du -s $REPORT_LOC/$OUTPUT_FILENAME.csv  | awk '{ print $1 }') KB" &&
	rm $REPORT_LOC/*${$}*
else
        echo $SQLFILE' blocked';
fi
