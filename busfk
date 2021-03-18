#!/bin/bash
set -e

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $(basename "$0") [regex]"
    echo
    echo "Calculate bus factor and fraction of lines edited by the most active contributor for the files in a git repository."
    echo "It serches the code in the current directory. The results can be filtered using a sed [regex] pattern."
    exit 0
fi

TMP_FILES="/tmp/busfk-files.tmp"
TMP_STATS="/tmp/busfk-results.tmp"

# cleanup the temporary files
clean () { rm -f "$TMP_FILES" /tmp/busfk-results.tmp; }

clean

if [ "$( git rev-parse --is-inside-work-tree 2>/dev/null )" != "true" ]; then
    echo "Error: $(pwd) is not a git repository"
    exit 1
fi

# list all files, ignore the .git directory
find . -type f -not -path "*/.git/*" 2>/dev/null >"$TMP_FILES"

# filter the files using a [pattern]
if [ -n "$1" ]; then
    sed -i -n "/$1/p" "$TMP_FILES"
fi

if [ ! -s "$TMP_FILES" ]; then
    echo "No files meet the criteria"
    exit 0
fi

while IFS= read -r file; do

    # skip files mentioned in .gitignore
    if [ -z "$( git check-ignore "$file" 2>&1 )" ]; then
        authors=$( git blame --line-porcelain "$file" 2>/dev/null \
                | sed -n 's/^author //p' \
                | sort \
                | uniq -c )

        # fraction of lines by the most active editor
        contrib=$( awk '{ if ($1 > max) max = $1; sum += $1 } END { if (sum > 0) printf "%.1f", max / sum * 100 }' <<< "$authors" )

        # number of unique editors
        busfactor=$( wc -l <<< "$authors" )

        lines=$( wc -l "$file" | awk '{ print $1 }' )

        # filter out empty files etc.
        if [ "$busfactor" -gt 0 ]; then
            printf "%4d %5.1f%% %6d %s\n" "$busfactor" "${contrib:-100.0}" "$lines" "$file" >> "$TMP_STATS"
        fi
    fi
done < "$TMP_FILES"

printf "  bf   max%%  lines path\n"
# sort by the bus factor
sort -k1,1 "$TMP_STATS"

printf "\nSummary (weighted averages):\n"
awk '{ l += $3; b += $1 * $3; f += $2 * $3 } END { printf "%4.1f %5.1f%% %6d", b/l, f/l, l }' "$TMP_STATS"
printf " %s\n" "$DIR"

clean
