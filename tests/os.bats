#!/usr/bin/env bats

setup() {
    source "$BATS_TEST_DIRNAME/../scripts/helper-functions.sh"
}

@test "detects macOS" {
    OSTYPE="darwin23"

    run get_os

    [ "$status" -eq 0 ]
    [ "$output" = "macOS" ]
}

@test "detects Linux and reads /etc/os-release" {
    OSTYPE="linux-gnu"

    run get_os

    [ "$status" -eq 0 ]
    [[ "$output" =~ ^Linux\ \(.*\)$ ]]
}

@test "detects Windows MSYS" {
    OSTYPE="msys"

    run get_os

    [ "$status" -eq 0 ]
    [ "$output" = "Windows (Bash Environment)" ]
}

@test "detects Windows Cygwin" {
    OSTYPE="cygwin"

    run get_os

    [ "$status" -eq 0 ]
    [ "$output" = "Windows (Bash Environment)" ]
}

@test "detects Windows MinGW" {
    OSTYPE="mingw64"

    run get_os

    [ "$status" -eq 0 ]
    [ "$output" = "Windows (Bash Environment)" ]
}

@test "detects BSD" {
    OSTYPE="freebsd"

    run get_os

    [ "$status" -eq 0 ]
    [ "$output" = "BSD" ]
}

@test "detects OpenBSD as BSD" {
    OSTYPE="openbsd"

    run get_os

    [ "$status" -eq 0 ]
    [ "$output" = "BSD" ]
}

@test "detects NetBSD as BSD" {
    OSTYPE="netbsd"

    run get_os

    [ "$status" -eq 0 ]
    [ "$output" = "BSD" ]
}

@test "detects Solaris" {
    OSTYPE="solaris"

    run get_os

    [ "$status" -eq 0 ]
    [ "$output" = "Solaris" ]
}

@test "falls back to uname when OSTYPE is unexpected" {
    OSTYPE="something-unexpected"

    uname() {
        echo "Plan9"
    }

    run get_os

    [ "$status" -eq 0 ]
    [ "$output" = "Unknown (Plan9)" ]
}

@test "falls back to Unknown OS when uname produces no output" {
    OSTYPE="something-unexpected"

    uname() {
        return 0
    }

    run get_os

    [ "$status" -eq 0 ]
    [ "$output" = "Unknown OS" ]
}
