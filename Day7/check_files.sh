FILE_PATH="$HOME/devops_journey/day2/warmup.txt"#!/bin/bash

# Define the file path to test
FILE_PATH="../day2/wormup.txt"

echo "Checking for file at: $FILE_PATH"

if [ -f "$FILE_PATH" ]; then
    echo "✅ Success: $FILE_PATH was found!"
else
    echo "❌ Alert: $FILE_PATH does not exist!"
fi
