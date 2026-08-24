#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/progress.sh"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TOTAL_SUBSTEPS=2

confirm_env_available() {
    if [[ -f "$PROJECT_DIR/.env" ]]; then
        set -o allexport
        source "$PROJECT_DIR/.env"
        set +o allexport
    else
        return 1
    fi
}

confirm_env_available

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