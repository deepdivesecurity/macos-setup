#!/bin/bash

TOTAL_STEPS=3
CURRENT_STEP=0
START_TIME=$(date +%s)

# ----------------------------------------
# Colors
# ----------------------------------------
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ----------------------------------------
# Progress Bar
# ----------------------------------------
progress_bar() {
    local current=$1
    local total=$2
    local width=40

    local percent=$((current * 100 / total))
    local completed=$((current * width / total))
    local remaining=$((width - completed))

    printf "\r["
    printf "%${completed}s" | tr ' ' '#'
    printf "%${remaining}s" | tr ' ' '-'
    printf "] %3d%%" "$percent"
}

# ----------------------------------------
# Step Handler
# ----------------------------------------
run_step() {
    # Collect first argument passed to function
    local description="$1"
    # Remove first argument
    shift

    # Increase global step counter by 1
    CURRENT_STEP=$((CURRENT_STEP + 1))
    echo ""
    # Print step and its descripton
    echo -e "${BOLD}[${CURRENT_STEP}/${TOTAL_STEPS}]${RESET} $description"

    printf "    "
    local step_start
    step_start=$(date +%s)

    # Run remaining arguments as a command
    if "$@"; then
        # Get ending timestamp after command
        local step_end
        step_end=$(date +%s)

        # Get number of seconds command took to complete
        local elapsed=$((step_end - step_start))
        echo -e "\r   ${GREEN}✓ OK${RESET} (${elapsed}s)"

        # Show overall progress in progress bar
        progress_bar "$CURRENT_STEP" "$TOTAL_STEPS"
        echo
    else
        echo -e "\r    ${RED}X FAILED${RESET} (${elapsed}s)"
        echo ""
        echo -e "${RED}Setup stopped because this step failed.${RESET}"
        exit 1
    fi
}

# ----------------------------------------
# Brew
# ----------------------------------------
configure_brew() {
    # Check if Homebrew is installed and install it if it's not
    if which brew; then
        echo "Brew is already installed"
    else
        echo "Test"
        #/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    BREWFILE_PATH=$(pwd)/Brewfile

    if [ ! -f "$BREWFILE_PATH" ]; then
        echo "Error: File '$BREWFILE_PATH' does not exist."
        exit 1
    else
        brew bundle --file=$BREWFILE_PATH
    fi

    return 0
}

# ----------------------------------------
# Finder
# ----------------------------------------
configure_finder() {
    defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
    defaults write com.apple.finder AppleShowAllFiles -bool "true"
    defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
    return 0
}

# ----------------------------------------
# Apply Changes
# ----------------------------------------
apply_changes() {
    killall Finder 2>/dev/null || true
    return 0
}

# ----------------------------------------
# Header
# ----------------------------------------
echo ""
echo -e "${CYAN}${BOLD}"
echo "========================================"
echo "||            macOS SETUP             ||"
echo "========================================"
echo -e "${RESET}"
echo "Starting setup..."
echo ""

# ----------------------------------------
# Steps
# ----------------------------------------
run_step "Configure Finder" configure_finder
run_step "Configure Brew" configure_brew
run_step "Apply Changes" apply_changes 

# ----------------------------------------
# Complete
# ----------------------------------------
END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))

echo ""
echo -e "${GREEN}${BOLD}"
echo "========================================"
echo "||          SETUP COMPLETE            ||"
echo "========================================"
echo -e "${RESET}"
echo "Completed $TOTAL_STEPS/$TOTAL_STEPS steps"
echo "Total time: ${TOTAL_TIME}s"
echo ""

exit 0