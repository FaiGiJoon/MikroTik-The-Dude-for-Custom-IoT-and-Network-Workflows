#!/usr/bin/env bash

# This script demonstrates how to create a "Future Tool" for The Dude.
# You can register this in The Dude Client under:
# Tools -> Settings -> Tools -> Add
# Name: Open Axis Camera
# Command: /custom-tools/open-axis-cam.sh [Device.FirstAddress]

IP_ADDRESS=$1

if [ -z "$IP_ADDRESS" ]; then
    echo "Usage: $0 <ip_address>"
    exit 1
fi

# Example action: Open the camera's web interface in the container's browser
# In Kasm/Webtop, you can use 'firefox' or 'chromium'
echo "Attempting to open camera at $IP_ADDRESS..."
firefox "http://$IP_ADDRESS" &
