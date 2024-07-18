#!/bin/bash

# Proceed without root to check environment variables and print info
echo "Running with USERNAME: $USERNAME"

# Only check for root if attempting to add a user
if [ ! -z "$USERNAME" ]; then
    if ! id "$USERNAME" &>/dev/null; then
        # Root check moved here
        if [ "$(id -u)" != "0" ]; then
            echo "User creation must be run as root" 1>&2
            exit 1
        fi

        useradd -m -s /bin/bash "$USERNAME"
        if [ $? -ne 0 ]; then
            echo "Failed to create user $USERNAME"
            exit 1
        fi
    fi
    # Ensure the home directory exists and set permissions
    if [ ! -d "/home/$USERNAME" ]; then
        mkdir -p "/home/$USERNAME"
        chown "$USERNAME":"$USERNAME" "/home/$USERNAME"
    fi
    exec su - "$USERNAME"
else
    exec su - default_user
fi
