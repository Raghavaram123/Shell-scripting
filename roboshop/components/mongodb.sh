#!/bin/bash

# Step 1: Setup MongoDB repos
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
if [ $? -eq 0 ]; then
  echo "Step 1: Setup MongoDB repos - Success"
else
  echo "Step 1: Setup MongoDB repos - Failure"
  exit 1
fi

# Step 2: Install Mongo & Start Service
yum install -y mongodb-org
systemctl enable mongod
systemctl start mongod
if [ $? -eq 0 ]; then
  echo "Step 2: Install Mongo & Start Service - Success"
else
  echo "Step 2: Install Mongo & Start Service - Failure"
  exit 1
fi

# Step 3: Update Listen IP address
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
systemctl restart mongod
if [ $? -eq 0 ]; then
  echo "Step 3: Update Listen IP address - Success"
else
  echo "Step 3: Update Listen IP address - Failure"
  exit 1
fi

# Step 4: Download the schema and inject it
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
if [ $? -eq 0 ]; then
  echo "Step 4: Download the schema - Success"
else
  echo "Step 4: Download the schema - Failure"
  exit 1
fi

cd /tmp
unzip mongodb.zip
cd mongodb-main
mongo < catalogue.js
if [ $? -eq 0 ]; then
  echo "Step 5: Inject schema (catalogue.js) - Success"
else
  echo "Step 5: Inject schema (catalogue.js) - Failure"
  exit 1
fi

mongo < users.js
if [ $? -eq 0 ]; then
  echo "Step 6: Inject schema (users.js) - Success"
else
  echo "Step 6: Inject schema (users.js) - Failure"
  exit 1
fi

echo "MongoDB installation and schema injection completed successfully."
