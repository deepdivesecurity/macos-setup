#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/progress.sh"

TOTAL_SUBSTEPS=2

# ----------------------------------------
# Finder
# ----------------------------------------
configure_finder() {
    defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv" || return 1
    defaults write com.apple.finder AppleShowAllFiles -bool "true" || return 1
    defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true" || return 1

    return 0
}

# ----------------------------------------
# Apply Changes
# ----------------------------------------
apply_changes() {
    killall Finder 2>/dev/null || true

    return 0
}

run_substep 1 "$TOTAL_SUBSTEPS" "Configuring Finder..." configure_finder
run_substep 2 "$TOTAL_SUBSTEPS" "Applying Changes..." apply_changes