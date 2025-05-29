#!/bin/bash

source ./common.sh
app_name=catalogue

CHECK_ROOT
APP_SETUP
NODEJS_SETUP
SYSTEMD_SETUP

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>> $LOG_FILE
VALIDATE $? "Installing MongoDB client"

STATUS=$(mongosh --host mongodb.daws84skc.site --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.daws84skc.site < /app/db/master-data.js &>> $LOG_FILE
    VALIDATE $? "Loading mongoDB data"
else
    echo -e "Data is already loaded.. $Y Skipping $N"
fi

PRINT_TIME