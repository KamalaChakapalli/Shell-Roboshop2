#!/bin/bash

source ./common.sh
app_name=frontend

CHECK_ROOT

dnf module disable nginx -y &>> $LOG_FILE
VALIDATE $? "Disabling default nginx"

dnf module enable nginx:1.24 -y &>> $LOG_FILE
VALIDATE $? "Enabling nginx:1.24"

dnf install nginx -y &>> $LOG_FILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>> $LOG_FILE
systemctl start nginx
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>> $LOG_FILE
VALIDATE $? "Removing default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOG_FILE
VALIDATE $? "Downloading frontend"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> $LOG_FILE
VALIDATE $? "Unzipping frontend"

rm -rf /etc/nginx/nginx.conf &>> $LOG_FILE
VALIDATE $? "Removing default nginx conf"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copying nginx.conf"

systemctl restart nginx
VALIDATE $? "Restarting nginx"
