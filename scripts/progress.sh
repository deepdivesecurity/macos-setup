#!/bin/bash

# ----------------------------------------
# Colors
# ----------------------------------------
GREEN='\033[0;32m'
RED='\033[0;31m'
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
# Substep
# ----------------------------------------
run_substep() {
    local current=$1
    local total=$2
    local description=$3
    shift 3

    printf "    [%d/%d] %-40s" "$current" "$total" "$description"

    if "$@"; then
        echo -e "${GREEN}✓${RESET}"
        progress_bar "$current" "$total"
        echo
    else
        echo -e "${RED}X${RESET}"
        return 1
    fi
}