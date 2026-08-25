#!/bin/bash

LOG_FILE="access.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "❌ Log file not found!"
    exit 1
fi

echo "=========================================="
echo "       AUTOMATED LOG AUDIT REPORT         "
echo "=========================================="

# 1. Count Total Requests
TOTAL_REQUESTS=$(wc -l < "$LOG_FILE")
echo "Total Requests Processed: $TOTAL_REQUESTS"

# 2. Count Error Codes (4xx and 5xx) using grep
ERROR_COUNT=$(grep -E -c " (4[0-9]{2}|5[0-9]{2}) " "$LOG_FILE")
echo "Total Client/Server Errors: $ERROR_COUNT"

echo "------------------------------------------"
echo "Top Requested Endpoints:"
# Extract request path using awk, sort, and count unique occurrences
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr

echo "------------------------------------------"
echo "Total Bandwidth Used:"
# Sum column 10 with awk
awk '{sum += $10} END {printf "%.2f KB\n", sum/1024}' "$LOG_FILE"
echo "=========================================="
