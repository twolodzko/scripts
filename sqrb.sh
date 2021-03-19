#!/bin/bash
set -e

if [[ "$#" -eq 0 ]]; then
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $(basename "$0") [branch] [target]"
    echo
    echo "Squash the git [branch] and rebase to the [target] branch. If [branch] is not given, use current branch. If [target] is not given, use root branch."
    exit 0
else
    BRANCH="$1"
fi

if [[ "$#" -lt 2 ]]; then
    # see: https://stackoverflow.com/a/44750379/3986320
    TARGET=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

    read -rp "Do you want to squash '$BRANCH' and rebase it to '$TARGET'? (y/[n])? " CONTINUE
    if [[ "$CONTINUE" != "y" ]]; then
        exit 0
    fi
else
    TARGET="$2"
fi

TEMPORARY="$BRANCH-squashed"

git fetch

git checkout "$BRANCH"
git diff "$TARGET"..HEAD > /tmp/1.diff

git checkout "$TARGET"
git checkout -b "$TEMPORARY"
git merge "$BRANCH"
git reset --soft "$TARGET"
git commit

git diff "$TARGET"..HEAD > /tmp/2.diff

if [[ $(diff /tmp/1.diff /tmp/2.diff) ]]; then
    git branch -D "$TEMPORARY"
    exit 1
else
    rm -f /tmp/1.diff /tmp/2.diff
fi

git push origin "$TEMPORARY:$BRANCH" --force

git checkout "$BRANCH"
git branch -D "$TEMPORARY"
git fetch --all
git reset --hard "origin/$BRANCH"
