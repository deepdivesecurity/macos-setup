#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/progress.sh"

TOTAL_SUBSTEPS=3

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
# Dock
# ----------------------------------------
configure_dock() {
    # Remove all existing persistent apps from the Dock
    defaults delete com.apple.dock persistent-apps 2>/dev/null || true

    # Add desired applications to the Dock
    defaults write com.apple.dock persistent-apps -array \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///System/Applications/Apps.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Brave%20Browser.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Visual%20Studio%20Code.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///System/Applications/Utilities/Terminal.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///System/Applications/Mail.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///System/Applications/Calendar.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///System/Applications/Notes.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///System/Applications/Utilities/Screenshot.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///System/Applications/App%20Store.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///System/Applications/System%20Settings.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>' 

    return 0
}

# configure_screensaver() {
#     defaults write com.apple.screensaver askForPassword -int 1 || return 1
#     defaults write com.apple.screensaver askForPasswordDelay -int 0 || return 1
#     return 0
# }

# ----------------------------------------
# Apply Changes
# ----------------------------------------
apply_changes() {
    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true
    return 0
}

run_substep 1 "$TOTAL_SUBSTEPS" "Configuring Finder..." configure_finder
run_substep 2 "$TOTAL_SUBSTEPS" "Configuring Dock..." configure_dock
#run_substep 3 "$TOTAL_SUBSTEPS" "Configuring Screensaver..." configure_screensaver
run_substep 3 "$TOTAL_SUBSTEPS" "Applying Changes..." apply_changes