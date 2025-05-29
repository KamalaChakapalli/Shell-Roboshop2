#!/bin/bash

source ./common.sh
app_name=shipping

CHECK_ROOT

echo "Please enter root password to setup"
read -s MYSQL_ROOT_PASSWORD
VALIDATE $? "Reading root password"

APP_SETUP
MAVEN_SETUP
SYSTEMD_SETUP

dnf install mysql -y &>> $LOG_FILE
VALIDATE $? "Installing MySQL"

mysql -h mysql.daws84skc.site -uroot -p$MYSQL_ROOT_PASSWORD -e 'use cities'
if [ $? -ne 0 ]
then
    mysql -h mysql.daws84skc.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/schema.sql &>> $LOG_FILE
    mysql -h mysql.daws84skc.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/app-user.sql &>> $LOG_FILE
    mysql -h mysql.daws84skc.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/master-data.sql &>> $LOG_FILE
else
    echo -e "Data is already loaded into MYSQL.. $Y SKIPPING $N"
fi
VALIDATE $? "Loading data into MYSQL"

systemctl restart shipping &>> $LOG_FILE
VALIDATE $? "Restarting shipping"

PRINT_TIME