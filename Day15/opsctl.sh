#!/bin/bash
set -euo pipefail

# 1. Load Configuration
CONFIG_FILE="ops.env"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: Configuration file '$CONFIG_FILE' is missing." >&2
    exit 1
fi
export $(grep -v '^#' "$CONFIG_FILE" | xargs)

# 2. Reusable Logging Functions
log_msg() {
    local LEVEL="$1"
    local MSG="$2"
    local TIMESTAMP
    TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] [$LEVEL] $MSG" | tee -a "${LOG_FILE:-opsctl.log}"
}

# 3. System Metrics Audit Module
check_system() {
    log_msg "INFO" "Running system resource audit..."
    
    local DISK_USAGE
    DISK_USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')
    
    local MEM_FREE
    MEM_FREE=$(free -m | awk '/Mem:/ {print $4}')
    
    log_msg "INFO" "Disk Usage: ${DISK_USAGE}% | Free Memory: ${MEM_FREE}MB"
    
    if [ "$DISK_USAGE" -ge "${DISK_ALERT_THRESHOLD:-80}" ]; then
        log_msg "WARN" "Disk usage exceeds threshold (${DISK_ALERT_THRESHOLD}%)!"
    else
        log_msg "SUCCESS" "System resources are within healthy limits."
    fi
}

# 4. Network & Service Probing Module
check_network() {
    log_msg "INFO" "Probing host connectivity for: $TARGET_HOST"
    
    if ping -c 1 -W 2 "$TARGET_HOST" > /dev/null 2>&1; then
        log_msg "SUCCESS" "Host $TARGET_HOST is reachable."
    else
        log_msg "ERROR" "Host $TARGET_HOST is unreachable!"
    fi

    log_msg "INFO" "Checking health endpoint: $HEALTH_ENDPOINT"
    local HTTP_CODE
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_ENDPOINT" || echo "000")

    if [ "$HTTP_CODE" -eq 200 ]; then
        log_msg "SUCCESS" "HTTP Endpoint returned status 200 OK."
    else
        log_msg "ERROR" "HTTP Endpoint check failed with status $HTTP_CODE!"
    fi
}

# 5. CLI Help Menu
show_help() {
    echo "Usage: ./opsctl.sh [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  system    Inspect disk space and memory availability"
    echo "  network   Verify network reachability and HTTP API health"
    echo "  all       Run complete infrastructure audit suite"
    echo "  help      Display this usage menu"
}

# 6. Command Dispatcher via Positional Parameters
COMMAND="${1:-help}"

case "$COMMAND" in
    system)
        check_system
        ;;
    network)
        check_network
        ;;
    all)
        log_msg "INFO" "Starting full system & network audit for: $APP_NAME"
        check_system
        check_network
        log_msg "SUCCESS" "Audit suite completed."
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        log_msg "ERROR" "Unknown command: $COMMAND"
        show_help
        exit 1
        ;;
esac
