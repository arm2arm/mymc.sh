#!/bin/bash

# Usage:
#   ./mymc.sh local_file_or_dir s3:bucket/path
#   ./mymc.sh s3:bucket/path local_file_or_dir



SRC="$1"
DST="$2"

if [ -z "$SRC" ] || [ -z "$DST" ]; then
    echo "Usage: $0 source_path s3:bucket/path OR s3:bucket/path dest_path"
    exit 1
fi

# Add MinIO alias (idempotent)
./mc alias set "$MC_ALIAS" "$MC_HOST" "$MC_ACCESS_KEY" "$MC_SECRET_KEY" > /dev/null

# Determine direction: upload or download
if [[ "$SRC" == s3:* ]]; then
    SRC_PATH="${SRC#s3:}"
    ./mc cp --recursive "$MC_ALIAS/$SRC_PATH" "$DST"
else
    DST_PATH="${DST#s3:}"
    ./mc cp --recursive "$SRC" "$MC_ALIAS/$DST_PATH"
fi
