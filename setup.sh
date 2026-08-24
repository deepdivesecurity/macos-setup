#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/progress.sh"

TOTAL_STEPS=4
CURRENT_STEP=0

START_TIME=$(date +%s)

# ----------------------------------------
# Colors
# ----------------------------------------
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ----------------------------------------
# Step Handler
# ----------------------------------------
run_step() {
    # Collect arguments passed to function
    local description="$1"
    local script="$2"

    # Increase global step counter by 1
    CURRENT_STEP=$((CURRENT_STEP + 1))
    echo ""
    # Print step and its descripton
    echo -e "${BOLD}[${CURRENT_STEP}/${TOTAL_STEPS}]${RESET} $description"

    local step_start
    step_start=$(date +%s)

    # Run remaining arguments as a command
    if bash "$SCRIPT_DIR/scripts/$script"; then
        # Get ending timestamp after command
        local step_end
        step_end=$(date +%s)

        # Get number of seconds command took to complete
        local elapsed=$((step_end - step_start))
        echo -e "\r   ${GREEN}✓ OK${RESET} (${elapsed}s)"

        # Show overall progress in progress bar
        echo "Overall Progress: "
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
run_step "Configuring MacOS" "macos-setup.sh"
run_step "Configuring MacOS Security" "macos-security.sh"
run_step "Configuring Brew" "brew-setup.sh"
run_step "Configuring Git" "git-setup.sh"

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