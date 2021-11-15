#!/bin/bash

# Export environment variables from the .env file.
# *Don't* run it directly. This script should be sourced.
#
#   $ . autoenv.sh <path>

if [[ $# -gt 0 ]]; then
    ENVFILE="$1"
else
    ENVFILE="$(pwd)/.env"
fi

while read -r line; do
    line="$(eval echo "$line")"
    echo "$line"

    # shellcheck disable=SC2163,SC2086
    export "$line"
done < "$ENVFILE"
