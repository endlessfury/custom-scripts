ServiceMonitor script

Created by Wojciech Olszewski

Overview:
The script is checking each defined endpoint status outputing the failed ones with mapped service and subsystem names.

It is adding /haelth endpoint to each url line. Some of the services don't have url at all or the /health isn't implemented. Those should be removed from csv input file.

Structure:
<path_to_script>/
├── ServiceMonitor
│   ├── monitorServices.sh # script which is checking the endpoints outputing to monitor_output.txt
│   ├── input.csv # input csv file generated via json converter from SD json
│   ├── check_monitor # main execution script
│   ├── mail_multiple.py # script executing email sending to defined recipient lists in recipients directory
│   └── mail_users.txt # defined recipient addresses
Arguments:
[Optional] debug - for HTTP outcome

Usage:
The Script can be run using monitorServices.sh or via check_monitor.sh for file generation and mail sending. 

Manually:

cd  <path_to_script>/ServiceMonitor/

./monitorServices.sh debug

or

./check_monitor

Cronned:


Additional information:
input.csv is generated csv from ServiceDiscovery output created via eg. https://beautifytools.com/excel-to-json-converter.php.