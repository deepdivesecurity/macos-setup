#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

readonly GIT_NAME="deepdivesecurity"
readonly GIT_EMAIL="165413290+deepdivesecurity@users.noreply.github.com"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/progress.sh"

TOTAL_SUBSTEPS=2

# ----------------------------------------
# Check Git
# ----------------------------------------
confirm_git_installed() {
    if ! command -v git >/dev/null 2>&1; then
        return 1
    fi

    return 0
}

# ----------------------------------------
# Git Username
# ----------------------------------------
configure_git_username() {
    confirm_git_installed || return 1

    if [ -z "$(git config --global user.name)" ]; then
        git config --global user.name "$GIT_NAME"
    fi

    return 0
}

# ----------------------------------------
# Git Email
# ----------------------------------------
configure_git_email() {
    confirm_git_installed || return 1

    if [ -z "$(git config --global user.email)" ]; then
        git config --global user.email "$GIT_EMAIL"
    fi

    return 0
}

run_substep 1 "$TOTAL_SUBSTEPS" "Configuring Global Git Username..." configure_git_username
run_substep 2 "$TOTAL_SUBSTEPS" "Configuring Global Git Email..." configure_git_email