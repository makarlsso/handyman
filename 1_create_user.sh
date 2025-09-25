#!/bin/bash

# A script to create a new user, add them to the wheel group,
# and set up their SSH authorized_keys file on AlmaLinux.

# --- Step 0: Check for root privileges ---
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi

# --- Step 1: Ask for a username ---
read -p "Enter the username for the new user: " USERNAME

# Check if the username is not empty
if [ -z "$USERNAME" ]; then
    echo "Username cannot be empty. Exiting."
    exit 1
fi

# Check if the user already exists
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists. Exiting."
    exit 1
fi

echo "Creating user '$USERNAME'..."

# --- Step 2: Create the user and their home directory ---
# The -m flag creates the user's home directory if it doesn't exist.
useradd -m "$USERNAME"

if [ $? -eq 0 ]; then
    echo "User '$USERNAME' created successfully."
else
    echo "Failed to create user '$USERNAME'. Exiting."
    exit 1
fi

# --- Step 2.5: Set a password for the new user ---
echo "Setting password for user '$USERNAME'..."
# The -s flag makes the input invisible for security.
read -s -p "Enter the new password: " PASSWORD
echo # Add a newline after the invisible password prompt
echo "$PASSWORD" | passwd --stdin "$USERNAME"

if [ $? -eq 0 ]; then
    echo "Password for '$USERNAME' set successfully."
else
    echo "Failed to set password for '$USERNAME'. Exiting."
    exit 1
fi

# --- Step 3: Add the user to the wheel group ---
echo "Adding user '$USERNAME' to the wheel group for sudo access."
# The -aG flags append the user to the specified group(s).
usermod -aG wheel "$USERNAME"

# --- Step 4: Set up SSH access ---
echo "Setting up SSH for user '$USERNAME'..."
USER_HOME=$(eval echo ~$USERNAME)
SSH_DIR="$USER_HOME/.ssh"
AUTH_KEYS_FILE="$SSH_DIR/authorized_keys"

# Create the .ssh directory with the correct permissions
mkdir -p "$SSH_DIR"

# Copy authorized_keys from root to the new user's directory
cp /root/.ssh/authorized_keys "$AUTH_KEYS_FILE"

# Set the correct ownership for the .ssh folder and authorized_keys file
chown -R "$USERNAME":"$USERNAME" "$SSH_DIR"

# Set the correct permissions for the .ssh directory (700 - rwx for owner only)
chmod 700 "$SSH_DIR"

# Set the correct permissions for the authorized_keys file (600 - rw for owner only)
chmod 600 "$AUTH_KEYS_FILE"

echo "SSH setup for user '$USERNAME' is complete."
echo "Script finished successfully."