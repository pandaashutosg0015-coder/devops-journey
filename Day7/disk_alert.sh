#!/bin/bash

# Ask the user for input
echo "Enter current disk usage percentage (1-100):"
read USAGE

# Check if usage is greater than 80%
if [ "$USAGE" -gt 80 ]; then
    echo "⚠️  ALERT: High Disk Usage detected ($USAGE%)!"
else
    echo "✅ Normal: Disk usage is safe ($USAGE%)."
fi
