#!/bin/bash

IFS=$'\n\t'

function isDowngrade() {
    local versionFrom
    local versionTo

    local part1From
    local part2From
    local part3From
    local part4From
    local part1To
    local part2To
    local part3To
    local part4To

    versionFrom="$1"
    versionTo="$2"

    # Not using sed, because it's not portable on macOS.
    # Unfortunately, this makes everything a bit slow. Then again, you won't run it a lot, most likely.
    part1From=$(echo "$versionFrom" | grep -Eo "^[0-9]+")
    part2From=$(echo "$versionFrom" | grep -Eo "^[0-9]+\.[0-9]+" | grep -Eo "[0-9]+$")
    part3From=$(echo "$versionFrom" | grep -Eo "^[0-9]+\.[0-9]+\.[0-9]+" | grep -Eo "[0-9]+$")
    part4From=$(echo "$versionFrom" | grep -Eo "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | grep -Eo "[0-9]+$")

    part1To=$(echo "$versionTo" | grep -Eo "^[0-9]+")
    part2To=$(echo "$versionTo" | grep -Eo "^[0-9]+\.[0-9]+" | grep -Eo "[0-9]+$")
    part3To=$(echo "$versionTo" | grep -Eo "^[0-9]+\.[0-9]+\.[0-9]+" | grep -Eo "[0-9]+$")
    part4To=$(echo "$versionTo" | grep -Eo "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | grep -Eo "[0-9]+$")

    if (( part1From > part1To )); then
        echo "YES"
        return 0
    elif (( part1From == part1To )); then
        if (( part2From > part2To )); then
            echo "YES"
            return 0
        elif (( part2From == part2To )); then
            if (( part3From > part3To )); then
                echo "YES"
                return 0
            elif (( part3From == part3To )); then
                if (( part4From > part4To )); then
                    echo "YES"
                    return 0
                fi
            fi
        fi
    fi
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

    # seems like a good shortcut, and would certainly improve performance - but it seems like I would miss some downgrades with this in place
#     if [ -n $( echo "$line" | grep "omitted for duplicate" ) ]; then
#         return 0
#     fi

    # Not using sed, because it's not portable on macOS.
    # Unfortunately, this makes everything a bit slow. Then again, you won't run it a lot, most likely.
    library=$(echo "$line" | grep -Eo "\+- \(?[a-z0-9.-]*:[a-z0-9.-]*:jar" | grep -Eo "[a-z0-9.-]+:[a-z0-9.-]+")
    versionFrom=$(echo "$line" | grep -Eo "version managed from [0-9]+\.[0-9]+(\.[0-9]+)?(\.[0-9]+)?[;)]" | grep -Eo "[0-9]+\.[0-9]+(\.[0-9]+)?(\.[0-9]+)?")
    versionTo=$(echo "$line" | grep -Eo ":jar:[0-9]+\.[0-9]+(\.[0-9]+)?(\.[0-9]+)?:(compile|test|runtime)" | grep -Eo "[0-9]+\.[0-9]+(\.[0-9]+)?(\.[0-9]+)?")

    if [ $(isDowngrade "$versionFrom" "$versionTo") == "YES" ]; then
        echo -e "$library \t downgraded from $versionFrom to $versionTo"
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
