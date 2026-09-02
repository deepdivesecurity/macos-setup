#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/progress.sh"

TOTAL_SUBSTEPS=2

# ----------------------------------------
# Brave Browser Configuration
# ----------------------------------------
configure_brave() {
    # Make a directory for Brave Browser preferences if it doesn't exist
#     sudo mkdir -p /Library/Managed Preferences/(id -un)/
#     cat > /Library/Managed Preferences/(id -un)/com.brave.Browser.plist <<EOL
# <?xml version="1.0" encoding="UTF-8"?>
# <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# <plist version="1.0">
# <dict>
#     <key>BraveRewardsDisabled</key>
#     <true/>
#     <key>BraveWalletDisabled</key>
#     <true/>
#     <key>BraveNewsDisabled</key>
#     <true/>
#     <key>BookmarkBarEnabled</key>
#     <true/>
#     <key>MetricsReportingEnabled</key>
#     <false/>
#     <key>SafeBrowsingExtendedReportingEnabled</key>
#     <false/>
#     <key>UrlKeyedAnonymizedDataCollectionEnabled</key>
#     <false/>
#     <key>FeedbackSurveysEnabled</key>
#     <false/>
#     <key>AutofillAddressEnabled</key>
#     <false/>
#     <key>AutofillCreditCardEnabled</key>
#     <false/>
#     <key>PasswordManagerEnabled</key>
#     <false/>
#     <key>EnableDoNotTrack</key>
#     <true/>
# </dict>
# </plist>
# EOL
    defaults write com.brave.Browser BraveRewardsDisabled -bool true || return 1
    defaults write com.brave.Browser BraveWalletDisabled -bool true || return 1
    defaults write com.brave.Browser BraveNewsDisabled -bool true || return 1
    defaults write com.brave.Browser BookmarkBarEnabled -bool true || return 1
    defaults write com.brave.Browser MetricsReportingEnabled -bool false || return 1
    defaults write com.brave.Browser SafeBrowsingExtendedReportingEnabled -bool false || return 1
    defaults write com.brave.Browser UrlKeyedAnonymizedDataCollectionEnabled -bool false || return 1
    defaults write com.brave.Browser FeedbackSurveysEnabled -bool false || return 1
    defaults write com.brave.Browser AutofillAddressEnabled -bool false || return 1
    defaults write com.brave.Browser AutofillCreditCardEnabled -bool false || return 1
    defaults write com.brave.Browser PasswordManagerEnabled -bool false || return 1
    defaults write com.brave.Browser EnableDoNotTrack -bool true || return 1

    return 0
}

# ----------------------------------------
# Apply Changes
# ----------------------------------------
apply_changes() {
    sudo killall cfprefsd || true

    return 0
}

run_substep 1 "$TOTAL_SUBSTEPS" "Configuring Brave Browser..." configure_brave
run_substep 2 "$TOTAL_SUBSTEPS" "Applying Changes..." apply_changes
