#!/bin/bash

# command before
# ./kafka-console-consumer.sh --bootstrap-server ip:25082 --topic xxx --property print.timestamp=true --from-beginning > event.txt
# use tip
# ./count_events.sh [start date] [end date] [filename] [data-type or . for all]

startDate=$1;
endDate=$2;
inputFile=$3;
dataName=$4;

# YYYY-MM-DD

calcStartDate=`date -d "$startDate" +%s`"000";
calcEndDate=`date -d "$endDate" +%s`"000";

#echo "RANGE: [$calcStartDate, $calcEndDate]"; # debug info

events=`cat $inputFile | grep $dataName | sed 's|CreateTime:||g' | awk -v SD="$calcStartDate" -v ED="$calcEndDate" '{ if ($1 >= SD && $1 <= ED) print $1 }' | wc -l`
echo "$inputFile containing $dataName from time-period [$startDate,$endDate] has $events records";
