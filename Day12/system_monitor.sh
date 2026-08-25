#!/bin/bash

# Define thresholds
DISK_THRESHOLD=80
REPORT_FILE="$HOME/devops_journey/Day12/system_report.log"

echo "==========================================" >> "$REPORT_FILE"
echo "Report Timestamp: $(date +'%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"

# 1. Inspect Root Disk Usage (%)
DISK_USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')
echo "Root Disk Utilization: ${DISK_USAGE}%" >> "$REPORT_FILE"

if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    echo "⚠️  [ALERT] Disk space is above ${DISK_THRESHOLD}% capacity!" >> "$REPORT_FILE"
else
    echo "✅ Disk space is healthy." >> "$REPORT_FILE"
fi

# 2. Inspect Free Memory (MB)
MEM_FREE=$(free -m | awk '/Mem:/ {print $4}')
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
echo "Available Memory: ${MEM_FREE}MB / ${MEM_TOTAL}MB" >> "$REPORT_FILE"
echo "==========================================" >> "$REPORT_FILE"
