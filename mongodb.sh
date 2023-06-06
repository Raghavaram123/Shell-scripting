#!/bin/bash 

COMPONENT=mongodb
LOGFILE="/tmp/${COMPONENT}.log"

ID=$(id -u)

if [ $ID -ne 0 ] ; then 
    echo -e "\e[31m This script is expected to be run by a root user or with a sudo privilege \e[0m"
    exit 1
fi 

stat() {
    if [ $1 -eq 0 ] ; then 
        echo -e "\e[32m success \e[0m"
    else 
        echo -e "\e[31m failure \e[0m"
        exit 2
    fi 
}

echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"

echo -n  "Configuring the $COMPONENT repo :"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $? 

echo -n "Installing $COMPONENT : "
yum install -y $COMPONENT-org   &>> $LOGFILE
stat $? 

echo -n "Enabling the DB visibility :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $? 

echo -n "Starting $COMPONENT : "
systemctl daemon-reload mongod      &>> $LOGFILE
systemctl enable mongod      &>> $LOGFILE
systemctl restart mongod       &>> $LOGFILE
stat $?

echo -n "Downloading the $COMPONENT schema:"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Extracting the $COMPONENT Schema:"
cd /tmp
unzip -o mongodb.zip   &>> $LOGFILE 
stat $? 

echo -n "Injecting the schema:"
cd $COMPONENT-main
mongo < catalogue.js       &>> $LOGFILE 
mongo < users.js           &>> $LOGFILE 
stat $? 


echo -e "*********** \e[35m $COMPONENT Installation is completed \e[0m ***********"
