#!/bin/bash

# Usage:
#   ./myrclone.sh local_file_or_dir s3:bucket/path

set -e

# Check if environment variables are defined
if [ -z "${MC_ALIAS+x}" ] || [ -z "${MC_HOST+x}" ] || [ -z "${MC_ACCESS_KEY+x}" ] || [ -z "${MC_SECRET_KEY+x}" ]; then
    # Check if .env file exists
    if [ ! -f ".env" ]; then
        echo "Error: .env file not found. Please ensure the .env file is present."
        exit 1
    fi
    # Load environment variables from .env
    source .env
fi

SRC="$1"
DST="$2"

if [ -z "$SRC" ] || [ -z "$DST" ]; then
    echo "Usage: $0 source_path s3:bucket/path OR s3:bucket/path dest_path"
    exit 1
fi

# Add MinIO alias (idempotent)
mc alias set "$MC_ALIAS" "$MC_HOST" "$MC_ACCESS_KEY" "$MC_SECRET_KEY" > /dev/null

# Check if either path is s3:
if [[ "$SRC" == s3:* ]]; then
    # Download from MinIO
    SRC_PATH="${SRC#s3:}"
    mc cp --recursive "$MC_ALIAS/$SRC_PATH" "$DST"
else
    # Upload to MinIO
    DST_PATH="${DST#s3:}"
    mc cp --recursive "$SRC" "$MC_ALIAS/$DST_PATH"
fi
