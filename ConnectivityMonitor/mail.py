#! /usr/bin/python

import smtplib

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# me == my email address
# you == recipient's email address
me = "<from_who>"
you = "<to_who>"
subject = "<email_subject>"

# Create message container - the correct MIME type is multipart/alternative.
msg = MIMEMultipart()
msg['Subject'] = subject
msg['From'] = me
msg['To'] = you

# Create the body of the message (a plain-text and an HTML version).
fpattach = open("<output_file_name>")
attach_text=fpattach.read()
#part2 = MIMEText(attach_text.encode('utf-8'), 'html', 'utf-8')
part2 = MIMEText(attach_text, 'html', 'utf-8')
#part2.add_header('Content-Disposition', 'attachment', filename='message.htm')
#encoders.encode_base64(part2)
fpattach.close()
# Record the MIME types of both parts - text/plain and text/html.
part2 = MIMEText(attach_text, 'html')

# Attach parts into message container.
# According to RFC 2046, the last part of a multipart message, in this case
# the HTML message, is best and preferred.
msg.attach(part2)

# Send the message via local SMTP server.
mail = smtplib.SMTP('<smtp_server>', <smtp_port>)

mail.ehlo()

mail.starttls()

mail.login('apikey', '<your_api_key>')
mail.sendmail(me, you, msg.as_string())
mail.quit()
