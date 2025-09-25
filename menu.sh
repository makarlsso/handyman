#!/bin/bash

# A TUI menu script to manage user creation.
# This script uses the 'select' command to provide a simple, interactive menu.

# --- Check for root privileges ---
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi

# --- Define menu options ---
# The options are stored in an array.
OPTIONS=("Create User" "Alter sshd port" "Exit")

# --- Set the menu prompt ---
# PS3 is a special variable that sets the prompt for the select command.
PS3="Please select an option: "

# --- Main menu loop ---
# The 'select' command will display the numbered options and wait for user input.
select OPTION in "${OPTIONS[@]}"
do
    case $OPTION in
        # Case 1: Create User
        "Create User")
            echo "You have selected 'Create User'."
            # Execute the create_user.sh script.
            # Make sure this script is in the same directory or provide the full path.
            ./1_create_user.sh
            # The 'break' command will exit the select loop after the script runs.
            break
            ;;

        # Case 1: Create User
        "Alter sshd port")
            echo "You have selected 'Alter sshd port'."
            # Execute the alter_sshd_port.sh script.
            # Make sure this script is in the same directory or provide the full path.
            ./2_alter_sshd_port.sh
            # The 'break' command will exit the select loop after the script runs.
            break
            ;;

        # Case 3: Exit
        "Exit")
            echo "Exiting."
            # The 'break' command will exit the select loop.
            break
            ;;
        
        # Default case for invalid input
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done