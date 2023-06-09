####################################
############# Overview: #############
#####################################
Script is intended to monitor execution of reports exported by NRMReportsExecutor logged in generation.log. Monitoring is based on checking file parameters. Rows and filesize are being monitored. Those parameters are saved during exportfile creation.

Thresholds are set for monitoring purposes with two levels: alert and lockdown. If lockdown is exceded then SQL is being blocked and export is not executed anymore in NRMReportsExecutor. SQL need to be manually moved to SQL directory. 

It is checking last two records based on the report name from configuration part and based on the today's and the previous day dates from last column of generation.log.

Script is scheduled each morning of each day.

#####################################
############# Location: #############
#####################################

Generation log: <logger_absolute_path>/generation.log

######################################
############# Structure: #############
######################################
<path_to_script>/

├── ReportsMonitor
│   ├── mail_multiple.py # mail multiple users python script
│   ├── mail_users.txt # user list for above mail_multiple script
│   ├── check_monitor # main execution script
│   ├── check_reports # script with threshold defininition and configuration, preparing output for above check_monitor script:q
|   └── monitor_output.txt # file containing html message output from above check_reports script
######################################
############# Arguments: #############
######################################
Script do not take any arguments.

##################################
############# Usage: #############
##################################
Script can be run using check_monitor. It sends email when any of the tresholds is met.

Manually:

cd <path_to_script>/ReportsMonitor/

./check_monitor

Cronned:

0 8 * * * <path_to_script>/ReportsMonitor/check_monitor

###################################################
############# Additional information: #############
###################################################
After adding new report to NRMReportsExecutor it should be also added to the monitor.