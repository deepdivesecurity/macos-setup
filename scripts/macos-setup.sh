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
    # Use list view as default
    defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv" || return 1
    # Show all files
    defaults write com.apple.finder AppleShowAllFiles -bool "true" || return 1
    # Show all filename extensions
    defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true" || return 1
    # Enable Three-finger drag
    defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true" || return 1
    # Enable Tap to click
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool "true" || return 1
    defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1 || return 1
    # Enable dark icon and widget style
    defaults write -g AppleIconAppearanceTheme -string "RegularDark" || return 1

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