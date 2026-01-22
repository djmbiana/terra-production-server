#!/bin/bash

# detects local network settings
LOCAL_NETWORK=$(ip route | grep "link src" | awk '{print $1}' | head -1)

if [ -z "$LOCAL_NETWORK" ]; then
    echo "Error: Couldnt detect local network"
    echo "Please edit this script and set your LOCAL_NETWORK manually"
    exit 1
fi

echo "Detected local network: $LOCAL_NETWORK"
echo "Continue? (yes/no)"
read CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Aborted. Edit LOCAL_NETWORK in this script if incorrect."
    exit 0
fi

# rests ufw settings
sudo ufw --force reset

# sets default ufw policies
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default deny routed

# allow ssh connections from local network only
echo "Configuring SSH access from $LOCAL_NETWORK..."
sudo ufw limit from $LOCAL_NETWORK to any port 22

# allows http/https
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# turn on ufw logging
sudo ufw logging medium

# turn on ufw
sudo ufw --force enable

echo "Settings are done!"
echo "Current status:"
sudo ufw status verbose
