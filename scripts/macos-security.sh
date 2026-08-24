#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/progress.sh"

TOTAL_SUBSTEPS=3

# ----------------------------------------
# Enable File Vault
# ----------------------------------------
enable_filevault() {
    # Check if File Vault is enabled and if not, enable it
    if ! fdesetup isactive >/dev/null 2>&1; then
        sudo fdesetup enable || return 1
    fi

    # Validate that File Vault was enabled
    if ! fdesetup isactive >/dev/null 2>&1; then
        return 1
    fi

    return 0
}

# ----------------------------------------
# Enable Firewall
# ----------------------------------------
enable_firewall() {  
    # Check if the firewall is enabled and if not, enable it
    if ! firewall_state=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>&1); then
        return 1
    fi
    
    case "$firewall_state" in
        *"State = 1"* | *"State = 2"*)
            :
            ;;
        *)
            sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
            sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
            ;;
    esac

    # Validate that the firewall was enabled
    if ! firewall_state=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>&1); then
        return 1
    fi

    case "$firewall_state" in
        *"State = 1"* | *"State = 2"*)
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

# ----------------------------------------
# Enable Firewall Stealth Mode
# ----------------------------------------
enable_firewall_stealth_mode() {  
    # Check if the firewall stealth mode is enabled
    if ! stealth_mode_state=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode 2>&1); then
        return 1
    fi
    
    if [ ! "$stealth_mode_state" = "Firewall stealth mode is on" ]; then
        sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
    fi

    # Check if the firewall stealth mode is enabled
    if ! stealth_mode_state=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode 2>&1); then
        return 1
    fi

    # Validate stealth mode was enabled
    if [ ! "$stealth_mode_state" = "Firewall stealth mode is on" ]; then
        return 1
    fi

    return 0
}

run_substep 1 "$TOTAL_SUBSTEPS" "Enabling File Vault" enable_filevault
run_substep 2 "$TOTAL_SUBSTEPS" "Enabling Firewall" enable_firewall
run_substep 3 "$TOTAL_SUBSTEPS" "Enabling Firewall Stealth Mode" enable_firewall_stealth_mode