#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

function isDowngrade() {
    local versionFrom
    versionFrom="$1"
    local versionTo
    versionTo="$2"

    # TODO compare versions
    echo "NO"
}

function printOutputIfDowngradeLine() {
    local line
    local library
    local versionFrom
    local versionTo

    line="$1"
    # [INFO]    |  +- (net.bytebuddy:byte-buddy:jar:1.14.12:test - version managed from 1.14.16; omitted for duplicate)
    # [INFO]    |  +- net.bytebuddy:byte-buddy-agent:jar:1.13.16:test (version managed from 1.14.12)

    # not using sed, because it's not portable on macOS
    library=$(echo "$line" | grep -Eo "+- \(?[a-z0-9.-]*:[a-z0-9.-]*:jar" | grep -Eo "[a-z0-9.-]+:[a-z0-9.-]+")
    versionFrom=$(echo "$line" | grep -Eo "version managed from [0-9]+\.[0-9]+\.[0-9]+[;)]" | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+")
    versionTo=$(echo "$line" | grep -Eo ":jar:[0-9]+\.[0-9]+\.[0-9]+:(compile|test)" | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+")

    if [ $(isDowngrade "$versionFrom" "$versionTo") == "YES" ]; then
      echo "$library \t downgraded from $versionFrom to $versionTo"
    fi
}

function showOnlyDownGradeLines() {
    if [ -t 0 ]; then
        # called "un-piped"
        echo "Usage: Use it in a pipe, e.g.
./mvnw dependency:tree -Dverbose | showOnlyDownGradeLines"

        # do not exit the whole shell if the user called this wrong
        set +e
        return 1
    fi
    # consume stdin
    while read -r line; do
        printOutputIfDowngradeLine "$line"
    done
    return 0
}
