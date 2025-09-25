#!/bin/bash

# This script finds all files with the .sh suffix in the current directory
# and its subdirectories, and makes them executable.

echo "Making all .sh files executable..."

# The 'find' command is used to locate files.
# .           - Search from the current directory.
# -type f     - Only find regular files (not directories).
# -name "*.sh" - Match files ending with .sh.
# -exec       - Execute a command on each file found.
# chmod +x {} - The command to make the file executable.
# \;          - Marks the end of the -exec command.
find . -type f -name "*.sh" -exec chmod +x {} \;

echo "Done. All .sh files in the current directory and subdirectories are now executable."