#!/bin/bash 

COMPONENT=frontend
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

echo -n "Installing Nginx :"
yum install nginx -y  &>> $LOGFILE
stat $?

echo -n "Downloading the ${COMPONENT} component :"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $?

echo -n "Performing Cleanup: "
cd /usr/share/nginx/html
rm -rf *    &>> $LOGFILE
stat $?

echo -n "Extracting ${COMPOMENT} component :"
unzip /tmp/${COMPONENT}.zip   &>> $LOGFILE
mv $COMPONENT-main/*  .
mv static/* . 
rm -rf ${COMPONENT}-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $? 


echo -n "Starting $COMPONENT service: "
systemctl enable nginx  &>> $LOGFILE
systemctl start nginx   &>> $LOGFILE
stat $?

echo -e "*********** \e[35m $COMPONENT Installation has Completed \e[0m ***********"

# It's always a great idea to perform validation before you get an exception.
# If the script is executed as a root user or as a sudo user, then it has to proceed.
# If not , I was to exit the script with some nice message.


# The frontend is the service in RobotShop to serve the web content over Nginx.

# Install Nginx.

# ```
# # yum install nginx -y
# # systemctl enable nginx
# # systemctl start nginx

# ```

# Let's download the HTDOCS content and deploy it under the Nginx path.

# ```
# # curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

# ```

# Deploy in Nginx Default Location.