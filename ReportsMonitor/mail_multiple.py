#! /usr/bin/python

import smtplib
import datetime
import platform
import os, fnmatch
import os.path

from os import path
from email import encoders
from email.message import Message
from email.mime.audio import MIMEAudio
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

EMAIL_SUBJECT = '<mail_subjecT>'
SEND_FROM = '<send_from>'

def get_users_data(file_name):
    user_name = []
    user_email = []
    #with open(file_name, mode='r', encoding='utf-8') as user_file:
    with open(file_name, mode='r') as user_file:
        for user_info in user_file:
            user_name.append(user_info.split()[0])
            user_email.append(user_info.split()[1])
    return user_name, user_email
    
def read_template(file_name):
    #with open(file_name, 'r', encoding='utf-8') as msg_template:
    with open(file_name, 'r') as msg_template:
        msg_template_content = msg_template.read()
    return Template(msg_template_content)

def main():
    # read users from the file
    user_name, user_email = get_users_data('<path_to_script>/ReportsMonitor/mail_users.txt') # read user details
    
    # Send the message via local SMTP server.
    mail = smtplib.SMTP('<smtp_server>', <smtp_port>)
    # username and password for smtdlib - apikey for 3uk
    mail.login('apikey', '<apikey>')

    # Get each user detail and send the email:
    for name, email in zip(user_name, user_email):
        # Create message container - the correct MIME type is multipart/alternative.
        msg = MIMEMultipart('alternative')
        msg['Subject'] = EMAIL_SUBJECT
        msg['From'] = SEND_FROM
        msg['To'] = email

        # Create the body of the message (a plain-text and an HTML version).
        fpattach = open("<path_to_script>/ReportsMonitor/<html_message_file>")
        attach_text=fpattach.read()
        part = MIMEText(attach_text, 'html', 'utf-8')
        fpattach.close()

        # Attach parts into message container.
        # According to RFC 2046, the last part of a multipart message, in this case
        # the HTML message, is best and preferred.
        # msg.attach(part1)
        msg.attach(part)

        mail.sendmail(SEND_FROM, email, msg.as_string())
        del msg
    # Terminate the SMTP session and close the connection
    mail.quit()
    
    
if __name__ == '__main__':
    main()
