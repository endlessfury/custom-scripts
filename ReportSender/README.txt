#####################################
############# Overview: #############
#####################################
The script sends an email with the desired files to desires groups of users.

It logs the activity and sends alert email when cannot send a file.


#####################################
############# Location: #############
#####################################

Logs location: <log_location>

######################################
############# Structure: #############
######################################
<script_path>/ReportSender

├── RecoMonitor
│   ├── send_report # script sending desired file from /home/oss/data to multiple recipients
│   ├── mail_multiple.py # script executing email sending to defined recipient lists in recipients directory
│   ├── message.txt # Prepared html template message in the emails
│   ├── recipients # directory with mail lists
│   │   └──  mail_lists.txt # files with  defined recipient addresses

######################################
############# Arguments: #############
######################################
Report_name - base name of the file, added to the email subject and generates log file based on this name
Location - with silent base of <relative_path_extension>
Recipient_list - file name in recipients directory without txt extension
[Optional] Period - default period for last file checking is 30 min, might be changed to any value
##################################
############# Usage: #############
##################################
The Script can be run using send_report. 

Manually:

cd <script_path>/ReportSender

./send_report <Report_name> <Location> <Recipient_list> <Period>

or

./send_report <Report_name> <Location> <Recipient_list>

Cronned:

## Report_name to wojtek
0 8 * * * <path_to_script>/ReportSender/send_report Report_name <relative_path_to_report>/Report_name wojtek > /dev/null
0 17 * * * <path_to_script>/ReportSender/send_report Report_name2 <relative_path_to_report>/Report_name2 wojtek > /dev/null

###################################################
############# Additional information: #############
###################################################
