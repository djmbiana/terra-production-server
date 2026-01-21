#!/bin/bash
# UFW CONFIG for Terra

# Resets UFW settings 
sudo ufw --force reset

# Setting default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default deny routed

# Allow SSH from local connection  only
sudo ufw limit from 192.168.122.0/24 to any port 22

# Allow HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Turn on UFW logging
sudo ufw logging medium

# Turn on UFW
sudo ufw enable

echo "Settings are done!"
echo "Current status"
sudo ufw status verbose
