#####################################
############# Overview: #############
#####################################
Script is executing sql and putting whole SQL*Plus output into csv file. Although the sql output is csv formated, SQL*Plus output is not formated to be used as csv file, needs postprocessing.

The output for the csv can be executed with different delimtiers, usually it is comma and this provides to the issue when we export data without quotation marks, because of data that we put in wrong format and SQL*Plus cannot read it correctly.

The script basically extracts data without qoutes, with temporar, safe delimiter and cuts the output of the SQL*Plus, adds quotation marks based on delimiter and changes the original delimiter of the choice.

######################################
############# Structure: #############
######################################
<path_to_script>/

├── NRMReportsExecutor
│   ├── SQLs
│   │   └── files.sql
│   ├── blockedSQLs
│   │   └── files.sql
│   └── generate_report.sh
######################################
############# Arguments: #############
######################################
SQL_file_name - in SQLs directory
Exported_file_name - without extension
Delimiter - usually just comma
Location - with silent base: <relative_path_extension>
##################################
############# Usage: #############
##################################
Usage can be devided into two parts:

1. Manual run

we need to enter script location
we put parameters that bash understands
example:
cd <path_to_script>/NRMReportsExecutor

./generate_report.sh <file.sql> <file_name> <delimiter> <location>

2. Automated run via Cron

Cron consider % as a new line so need to be escaped if needed. This need to be known when using date command in the file_name argument.

Generation log need to be directed to the location: /mnt/NRM.comarch.backup/NRM_reports/generation.log.

ReportsMonitor tool is based on cronned jobs and output from above log file.

Example structure in crontab: 

###### Wojciech Olszewski scripts

#### CSV reports generation

## Report1
0 0 * * * <path_to_script>/generate_report.sh Report1.sql Report1_$(date +"\%Y\%m\%d\%H\%M\%S") , <relative_dir> >> <logger_absolute_path>/generation.log
## Report2
2 0 * * * <path_to_script>/generate_report.sh Report2.sql Report2_$(date +"\%Y\%m\%d\%H\%M\%S") , <relative_dir> >> <logger_absolute_path>/generation.log
