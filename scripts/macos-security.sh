#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/progress.sh"

TOTAL_SUBSTEPS=1

# ----------------------------------------
# Enable File Vault
# ----------------------------------------
enable_filevault() {
    if ! fdesetup isactive >/dev/null 2>&1; then
        sudo fdesetup enable
    fi

    return 0
}

run_substep 1 "$TOTAL_SUBSTEPS" "Enabling File Vault" enable_filevault