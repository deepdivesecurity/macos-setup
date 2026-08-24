#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/progress.sh"

TOTAL_SUBSTEPS=2

# ----------------------------------------
# Enable File Vault
# ----------------------------------------
enable_filevault() {
    if ! fdesetup isactive >/dev/null 2>&1; then
        sudo fdesetup enable
    fi

    return 0
}

# ----------------------------------------
# Enable Firewall
# ----------------------------------------
enable_firewall() {
    if ! firewall_state=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>&1); then
        echo "Unable to determine firewall state..."
        return 1
    fi
    
    case "$firewall_state" in
        *"State = 1"* | *"State = 2"*)
            :
            ;;
        *)
            sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
            ;;
    esac

    return 0
}

run_substep 1 "$TOTAL_SUBSTEPS" "Enabling File Vault" enable_filevault
run_substep 2 "$TOTAL_SUBSTEPS" "Enabling Firewall" enable_firewall