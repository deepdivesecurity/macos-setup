#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/progress.sh"

TOTAL_SUBSTEPS=2

# ----------------------------------------
# Install Brew
# ----------------------------------------
install_brew() {
    # Check if Homebrew is installed and install it if it's not
    if ! command -v brew >/dev/null 2>&1; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    return 0
}

# ----------------------------------------
# Install Brew Apps
# ----------------------------------------
install_brew_apps() {
    BREWFILE_PATH=$(pwd)/Brewfile

    if [ ! -f "$BREWFILE_PATH" ]; then
        echo "Error: File '$BREWFILE_PATH' does not exist."
        exit 1
    else
        brew bundle --file=$BREWFILE_PATH
    fi

    return 0
}

run_substep 1 "$TOTAL_SUBSTEPS" "Installing Homebrew" install_brew
run_substep 2 "$TOTAL_SUBSTEPS" "Installing Homebrew Apps" install_brew_apps