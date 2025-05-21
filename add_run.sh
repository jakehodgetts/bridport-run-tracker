#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: ./add_run.sh path_to_new_gpx_file"
  exit 1
fi

NEW_GPX="$1"
BASENAME=$(basename "$NEW_GPX")

# Copy the new GPX file into runs folder
cp "$NEW_GPX" runs/

# Check if the file is already in index.html to avoid duplicates
if grep -q "$BASENAME" index.html; then
  echo "$BASENAME already listed in index.html"
else
  # Insert the new file into runTracks array before the closing bracket
  sed -i "/const runTracks = \[/,/\];/{
    /];/i \  'runs/$BASENAME', 
  }" index.html
  echo "Added $BASENAME to index.html"
fi

# Git add, commit, push
git add runs/"$BASENAME" index.html
git commit -m "Add new run $BASENAME"
git push
