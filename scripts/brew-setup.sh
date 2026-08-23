#!/bin/bash

# Exit script if command fails
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/progress.sh"

TOTAL_SUBSTEPS=1

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

run_substep 1 "$TOTAL_SUBSTEPS" "Configuring Brew" configure_brew