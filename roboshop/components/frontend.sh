#!/bin/bash

# Install Nginx
echo "Installing Nginx..."
if yum install nginx -y; then
  echo "Nginx installation succeeded."
else
  echo "Nginx installation failed."
  exit 1
fi

# Start Nginx service
echo "Starting Nginx service..."
if systemctl enable nginx && systemctl start nginx; then
  echo "Nginx service started successfully."
else
  echo "Failed to start Nginx service."
  exit 1
fi

# Download HTDOCS content and deploy it under the Nginx path
echo "Downloading HTDOCS content..."
if curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"; then
  echo "HTDOCS content download succeeded."
else
  echo "HTDOCS content download failed."
  exit 1
fi

# Deploy in Nginx Default Location
echo "Deploying content to Nginx default location..."
cd /usr/share/nginx/html
rm -rf *
if unzip /tmp/frontend.zip && mv frontend-main/* . && mv static/* . && rm -rf frontend-main README.md && mv localhost.conf /etc/nginx/default.d/roboshop.conf; then
  echo "Content deployment succeeded."
else
  echo "Content deployment failed."
  exit 1
fi

# Restart Nginx
echo "Restarting Nginx..."
if systemctl restart nginx; then
  echo "Nginx restart succeeded."
else
  echo "Nginx restart failed."
  exit 1
fi

echo "Frontend deployment completed successfully."
