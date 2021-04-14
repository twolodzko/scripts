#!/bin/bash

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $(basename "$0") [pattern] [dir]"
    echo
    echo "Count lines for all the filenames that match the [pattern] within the [dir] directory. By default, consider all files in current directory."
    exit 0
fi

DIR="${2:-$(pwd)}"

# shellcheck disable=SC2086
( find "$DIR" -type f -name "${1:-*}" -not -path '*/\.git/*' -print0 | xargs -0 cat 2> /dev/null ) | wc -l
