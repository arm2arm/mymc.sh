#!/bin/bash

# Usage:
#   ./mymc.sh local_file_or_dir s3:bucket/path
#   ./mymc.sh s3:bucket/path local_file_or_dir

set -e

# Function to check which MC_ variables are missing
missing_vars=()
check_mc_env_vars() {
    [ -z "$MC_ALIAS" ] && missing_vars+=("MC_ALIAS")
    [ -z "$MC_HOST" ] && missing_vars+=("MC_HOST")
    [ -z "$MC_ACCESS_KEY" ] && missing_vars+=("MC_ACCESS_KEY")
    [ -z "$MC_SECRET_KEY" ] && missing_vars+=("MC_SECRET_KEY")
}

check_mc_env_vars

# Try loading from .env if any are missing
if [ ${#missing_vars[@]} -gt 0 ]; then
    if [ ! -f ".env" ]; then
        echo "Error: The following environment variables are not set: ${missing_vars[*]}"
        echo "Also, .env file is not found. Please export them or provide a .env file."
        exit 1
    fi
    # shellcheck disable=SC1091
    source .env

    # Clear and re-check after sourcing
    missing_vars=()
    check_mc_env_vars
    if [ ${#missing_vars[@]} -gt 0 ]; then
        echo "Error: After sourcing .env, still missing: ${missing_vars[*]}"
        exit 1
    fi
fi

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
