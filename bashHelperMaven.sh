#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

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
        # do nothing
        true
    done
    return 0
}
