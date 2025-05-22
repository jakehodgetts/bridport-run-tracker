#!/bin/bash

# Exit on any error
set -e

# Check if GPX file path is provided
if [ -z "$1" ]; then
  echo "Usage: ./add_run.sh /path/to/your_run.gpx"
  exit 1
fi

GPX_SOURCE="$1"
GPX_FILENAME=$(basename "$GPX_SOURCE")
DEST_FOLDER="runs"
DEST_PATH="$DEST_FOLDER/$GPX_FILENAME"

# Copy GPX file
mkdir -p "$DEST_FOLDER"
cp "$GPX_SOURCE" "$DEST_PATH"
echo "Copied $GPX_FILENAME to $DEST_FOLDER/"

# Generate index.json
echo "Generating index.json..."
python3 - <<EOF
import os
import json

gpx_files = [f for f in os.listdir("runs") if f.endswith(".gpx")]
with open("index.json", "w") as f:
    json.dump(gpx_files, f, indent=2)
EOF

echo "index.json generated with all .gpx files"

# Stage files
git add "$DEST_PATH" index.json
git commit -m "Add new run $GPX_FILENAME"
git push

echo "Run $GPX_FILENAME added, committed, and pushed successfully."
