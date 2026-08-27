#!/bin/bash

# Abort on non-zero exitstatus; Abort on unbound variable; Don't hide errors within pipes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/progress.sh"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TOTAL_SUBSTEPS=2

read_env() {
    ENV_FILE="$PROJECT_DIR/.env"

    # Check if .env file exists
    if [[ ! -f "$ENV_FILE" ]]; then
        return 1
    fi

    while IFS= read -r line || [ -n "$line" ]; do
        # Skip lines that are empty or start with a comment (#)
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        # Strip leading/trailing whitespaces if necessary
        line=$(echo "$line" | xargs)

        # Validate that the line matches a standard KEY=VALUE format
        if [[ "$line" =~ ^[a-zA-Z_][a-zA-Z0-9_]*= ]]; then
            export "$line"
        fi
    done < "$ENV_FILE"

    return 0
}

read_env

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
        echo "$GIT_NAME"
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