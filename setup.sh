#!/bin/bash

# Check if Homebrew is installed and install it if it's not
if which brew; then
    echo "Brew is already installed"
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREWFILE_PATH=$(pwd)/Brewfile

if [ ! -f "$BREWFILE_PATH" ]; then
    echo "Error: File '$BREWFILE_PATH' does not exist."
    exit 1
else
    brew bundle --file=$BREWFILE_PATH
fi