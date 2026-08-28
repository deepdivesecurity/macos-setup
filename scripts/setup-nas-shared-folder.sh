#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/progress.sh"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

read_env() {
    ENV_FILE="$PROJECT_DIR/.env"

    # Check if .env file exists
    if [[ ! -f "$ENV_FILE" ]]; then
        return 1
    fi

    while IFS= read -r line || [ -n "$line" ]; do
        # Skip lines that are empty or start with a comment (#)
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        # Strip leading/trailing whitespaces if necessary
        line=$(echo "$line" | xargs)

        # Validate that the line matches a standard KEY=VALUE format
        if [[ "$line" =~ ^[a-zA-Z_][a-zA-Z0-9_]*= ]]; then
            export "$line"
        fi
    done < "$ENV_FILE"

    return 0
}

read_env

# Check if NAS is reachable before asking for info
if ! ping -c 1 -w 2 "$NAS_IP" > /dev/null 2>&1; then
    echo "Error: NAS at $NAS_IP is not reachable. Check your network."
    exit 1
fi

echo "NAS is online. Prompting for credentials..."

# 1. Pop up a native macOS dialog to ask for the NAS Username
USER_INPUT=$(osascript -e 'display dialog "Enter your Synology Username:" default answer "" with title "NAS Setup" buttons {"Cancel", "OK"} default button "OK"')
if [ $? -ne 0 ]; then echo "Setup cancelled."; exit 1; fi
NAS_USER=$(echo "$USER_INPUT" | textutil -convert txt -stdin -stdout | awk -F 'text returned:' '{print $2}')

# 2. Pop up a native macOS dialog to ask for the Password (masked)
PASS_INPUT=$(osascript -e 'display dialog "Enter your Synology Password:" default answer "" with title "NAS Setup" buttons {"Cancel", "OK"} default button "OK" with hidden answer')
if [ $? -ne 0 ]; then echo "Setup cancelled."; exit 1; fi
NAS_PASS=$(echo "$PASS_INPUT" | textutil -convert txt -stdin -stdout | awk -F 'text returned:' '{print $2}')

# Remove trailing whitespaces if any
NAS_USER=$(echo "$NAS_USER" | xargs)
NAS_PASS=$(echo "$NAS_PASS" | xargs)

echo "Attempting to mount and save credentials to Keychain..."

# 3. Mount using the explicit credentials, triggering macOS to remember them
osascript -e "mount volume \"smb://$NAS_USER:$NAS_PASS@$NAS_IP/$SHARE_NAME\""

if [ $? -eq 0 ]; then
    echo "--------------------------------------------------------"
    echo "Success! $SHARE_NAME is now mounted under /Volumes/"
    echo "macOS has securely saved your credentials to the Keychain."
    echo "From now on, you can use a simpler script without passwords."
    echo "--------------------------------------------------------"
else
    echo "Error: Failed to mount. Please verify your username and password."
    exit 2
fi
