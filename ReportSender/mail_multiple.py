#! /usr/bin/python

import smtplib
import datetime
import platform
import os, fnmatch
import os.path
import mimetypes
import sys

from os import path
from email import encoders
from email.message import Message
from email.mime.audio import MIMEAudio
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication

FILE_NAME = sys.argv[1]
REPORT_NAME = sys.argv[2]
MAIL_LIST = sys.argv[3]
TEMPORAR_FILE = sys.argv[4]
EMAIL_SUBJECT = REPORT_NAME + ' Report'
SEND_FROM = '<mail_from>'

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
    user_name, user_email = get_users_data(MAIL_LIST) # read user details
    
    # Send the message via local SMTP server.
    mail = smtplib.SMTP('<smtp_server>', <smtp_port>)
    # username and password for smtdlib - apikey for 3uk
    mail.login('apikey', '<api_key>')

    # Get each user detail and send the email:
    for name, email in zip(user_name, user_email):
        # Create message container - the correct MIME type is multipart/alternative.
        msg = MIMEMultipart()
        msg['Subject'] = EMAIL_SUBJECT
        msg['From'] = SEND_FROM
        msg['To'] = email

        # Create the body of the message (a plain-text and an HTML version).
        fpattach = open("<message_file>")
        attach_text=fpattach.read()
        part = MIMEText(attach_text, 'html', 'utf-8')
        fpattach.close()

        # Attach parts into message container.
        # According to RFC 2046, the last part of a multipart message, in this case
        # the HTML message, is best and preferred.
        # msg.attach(part1)
        msg.attach(part)
       	
	if path.exists(FILE_NAME) and path.isfile(FILE_NAME):
          gz_file = open(FILE_NAME,'rb')
          gz_part = MIMEBase('application', 'octet-stream')
          gz_part.set_payload(gz_file.read())
       	  gz_file.close()
          encoders.encode_base64(gz_part)
          gz_part.add_header('Content-Disposition', 'attachment', filename=TEMPORAR_FILE)
          msg.attach(gz_part)
          mail.sendmail(SEND_FROM, email, msg.as_string())    
    
    #del msg
    # Terminate the SMTP session and close the connection
    mail.quit()
   
    
if __name__ == '__main__':
    main()

