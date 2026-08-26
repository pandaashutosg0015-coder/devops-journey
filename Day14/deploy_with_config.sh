#!/bin/bash
set -euo pipefail

CONFIG_FILE="app.env"

# 1. Validate configuration file existence
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Configuration file '$CONFIG_FILE' not found!"
    exit 1
fi

# 2. Safely load key-value pairs without executing arbitrary code
export $(grep -v '^#' "$CONFIG_FILE" | xargs)

# 3. Verify required variables are populated
: "${ENVIRONMENT:?ENVIRONMENT variable is required}"
: "${PORT:?PORT variable is required}"
: "${API_KEY:?API_KEY variable is required}"

echo "=========================================="
echo "       DEPLOYMENT INITIALIZATION          "
echo "=========================================="
echo "Target Environment : $ENVIRONMENT"
echo "Listening Port     : $PORT"
echo "Database Host      : ${DB_HOST:-localhost}"

# 4. Mask sensitive secrets in logs
MASKED_KEY="${API_KEY:0:4}****${API_KEY: -4}"
echo "API Key Loaded     : $MASKED_KEY"
echo "=========================================="
echo "✅ Deployment configured successfully."
