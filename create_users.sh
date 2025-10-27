#!/bin/bash
# ==========================
# Basic Bash Automation - Create User Accounts
# ==========================

# Input file containing usernames
USER_FILE=Users.txt

# Output log for created users
LOG_FILE=Created_Users.log

# Password
DEFAULT_PASS="P@ssw0rd!"

# Sanity check for root access and file existance
if [ "$EUID" -ne 0 ]; then  
    echo "Error: Please run as root (use sudo)."  
    exit 13  
elif [ ! -f "$USER_FILE" ]; then  
    echo "Error: User file '$USER_FILE' not found!"  
    exit 44  
else  
    echo "Starting user creation process..."  
    echo "---------------------------------"  
fi

# Create/clear the log file
> "$LOG_FILE"

# IFS= treats each line as its own insteading of seperating it with spaces
# read -r username reads one line from the file and puts it into the variable username
# also prevents \n from being treated as escape characters
while IFS= read -r username; do

	# Skip empty lines (-z skips empty lines)
	[ -z "$username" ] && continue

	# Check if user already exists and logs and deletes output to terminal
	if id "$username" &>/dev/null; then
		echo "User $username already exists, skipping..." | tee -a  "$LOG_FILE"
		continue
	fi

	# Create user with home directory with -m
	useradd -m "$username" &>/dev/null

	# Set the unique password (quietly)
	echo "${username}:${DEFAULT_PASS}" | chpasswd

	# Force password change on next login with -e
	passwd -e "$username" &>/dev/null

	# Confirm creation with tee -a, appending it to the existing log file
	echo "User $username created successfully." | tee -a "$LOG_FILE"

# Redirects input back into the command at the beginning of the loop
done < "$USER_FILE"

echo "----------------------------------"
echo "User creation process completed."
echo "All created users have been logged in $LOG_FILE."
