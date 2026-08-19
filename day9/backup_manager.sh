#!/bin/bash

# Function accepting SOURCE ($1) and DESTINATION ($2)
create_backup() {
    local SRC="$1"
    local DEST="$2"

    if [ ! -f "$SRC" ]; then
        echo "❌ [ERROR] Source file '$SRC' does not exist."
        return 1
    fi

    local TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
    cp "$SRC" "${DEST}/backup_${TIMESTAMP}.bak"

    if [ $? -eq 0 ]; then
        echo "✅ [SUCCESS] Backup created for '$SRC' in '$DEST'"
        return 0
    else
        echo "❌ [ERROR] Failed to copy '$SRC'."
        return 1
    fi
}

# Setup test environment
mkdir -p ./backups
touch data.txt

echo "=== Test Case 1: Valid File ==="
create_backup "data.txt" "./backups"

echo "=== Test Case 2: Missing File ==="
create_backup "missing.txt" "./backups"
