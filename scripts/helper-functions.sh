#!/usr/bin/env bash

get_os() {
    case "$OSTYPE" in
        darwin*)
            echo "macOS"
            ;;
        linux*)
            # 2. If it's Linux, check /etc/os-release for the distribution name
            if [[ -f /etc/os-release ]]; then
                # Source the file to read $NAME or $ID variables safely
                # (Standard on modern systemd and non-systemd Linux distros)
                . /etc/os-release
                echo "Linux ($NAME)"
            else
                echo "Linux (Unknown Distro)"
            fi
            ;;
        msys*|cygwin*|mingw*)
            echo "Windows (Bash Environment)"
            ;;
        freebsd*|openbsd*|netbsd*)
            echo "BSD"
            ;;
        solaris*)
            echo "Solaris"
            ;;
        *)
            # Fallback to the traditional 'uname' command if $OSTYPE is empty or unexpected
            local uname_os
            uname_os=$(uname -s 2>/dev/null)
            if [[ -n "$uname_os" ]]; then
                echo "Unknown ($uname_os)"
            else
                echo "Unknown OS"
            fi
            ;;
    esac

    return 0
}

upgrade_mise() {
    mise upgrade || return 1

    return 0
}

upgrade_uv_tools() {
    uv tool upgrade --all || return 1

    return 0
}

update_and_upgrade_brew() {
    brew update && brew upgrade -y && brew cleanup || return 1

    return 0
}
