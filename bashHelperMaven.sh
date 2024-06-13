#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

function showOnlyDownGradeLines() {

    # consume stdin
    while read -r line; do
        # do nothing
        true
    done
    return 0
}
