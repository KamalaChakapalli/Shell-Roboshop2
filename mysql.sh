#!/bin/bash

source ./common.sh
app_name=mysql

CHECK_ROOT

echo "Please enter root password to setup"
read -s MYSQL_ROOT_PASSWORD
VALIDATE $? "Setting root password"

dnf install mysql-server -y &>> $LOG_FILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>> $LOG_FILE
VALIDATE $? "Enabling MySQL"

systemctl start mysqld  &>> $LOG_FILE
VALIDATE $? "Starting MySQL"

mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD &>> $LOG_FILE
VALIDATE $? "Setting MySQL root password"

PRINT_TIME