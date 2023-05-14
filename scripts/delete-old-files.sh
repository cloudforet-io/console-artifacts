#!/bin/sh
echo "Remove files in $1 which are older than $2"
echo "Current directory: $(pwd)"
DIR=$1
DAYS_OLD=$2
FILES="$(git ls-tree --name-only HEAD ./$DIR/.)"
IFS=printf "\n"

echo "\nAll files in $DIR:"
for f in $FILES; do
    str="$(git --no-pager log -1 --format="%cr" -- $f)"
    echo "$f -- $str"
done

echo "\nAll files before '$DAYS_OLD' in $DIR:"
for f in $FILES; do
    satisfied="$(git --no-pager log -1 --before="$DAYS_OLD" --format="%cr" -- $f)"
    if [ -n "$satisfied" ]; then
      echo "$f -- $satisfied";
      rm -rf $f
    fi
done