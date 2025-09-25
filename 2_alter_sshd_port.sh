#!/bin/bash

# A script to change the SSH port in the sshd_config file.
# This script must be run as root.

# --- Step 0: Check for root privileges ---
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

# --- Step 1: Prompt for the new port number ---
read -p "Enter the new SSH port number (default: 51022): " NEW_PORT

# Use the default port if the input is empty
if [ -z "$NEW_PORT" ]; then
    NEW_PORT="51022"
fi

# Validate that the input is a number
if ! [[ "$NEW_PORT" =~ ^[0-9]+$ ]]; then
    echo "Error: '$NEW_PORT' is not a valid number. Exiting."
    exit 1
fi

# --- Step 2: Alter the sshd_config file ---
SSHD_CONFIG_FILE="/etc/ssh/sshd_config"

echo "Attempting to change the SSH port to $NEW_PORT in $SSHD_CONFIG_FILE..."

# Check if the file exists
if [ ! -f "$SSHD_CONFIG_FILE" ]; then
    echo "Error: The sshd_config file was not found at $SSHD_CONFIG_FILE. Exiting."
    exit 1
fi

# Use sed to find and replace the 'Port' setting.
# The `sed` command performs a substitution (s) on each line.
# It handles two cases:
# 1. A commented-out line with "Port" (e.g., #Port 22)
# 2. An uncommented line with "Port" (e.g., Port 22)
# In both cases, it replaces the line with "Port $NEW_PORT".
sed -i -E "s/^[#]?Port.*/Port $NEW_PORT/" "$SSHD_CONFIG_FILE"

if [ $? -eq 0 ]; then
    echo "SSH port successfully updated to $NEW_PORT."
    echo "You must restart the SSH service for the changes to take effect."
    
    # --- Step 3: Prompt to restart the SSH service ---
    read -p "Do you want to restart the sshd service now? (y/n): " RESTART_SERVICE
    if [[ "$RESTART_SERVICE" =~ ^[Yy]$ ]]; then
        systemctl restart sshd
        if [ $? -eq 0 ]; then
            echo "sshd service restarted successfully."
            echo "You can now connect to your server via the new port."
        else
            echo "Failed to restart the sshd service. Please restart it manually."
        fi
    else
        echo "Please remember to manually restart the sshd service when you are ready."
    fi
else
    echo "Failed to update the SSH port. Please check the file permissions."
fi