#!/bin/bash

if [[ "$#" -lt 2 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $(basename "$0") files... container:directory"
    echo
    echo "Copy files to docker container directory."
    exit 0
fi

TARGET="${*: -1}"

for filename in ${*:1:$#-1}; do
    cmd="docker cp $filename $TARGET"
    echo "$cmd"
    eval "$cmd"
done
