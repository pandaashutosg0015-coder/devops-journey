#!/bin/bash

SERVICE_NAME="dummy_daemon.sh"
LOG_FILE="watchdog.log"

log_message() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Create a dummy long-running background service
cat << 'EOF' > dummy_daemon.sh
#!/bin/bash
while true; do
    sleep 1
done
EOF
chmod +x dummy_daemon.sh

# Start the service in the background if not already active
start_service() {
    log_message "⚠️ $SERVICE_NAME is down! Launching new instance..."
    nohup ./$SERVICE_NAME > /dev/null 2>&1 &
    log_message "✅ $SERVICE_NAME started with PID: $!"
}

# Check if process is running
if pgrep -f "$SERVICE_NAME" > /dev/null; then
    CURRENT_PID=$(pgrep -f "$SERVICE_NAME" | head -n 1)
    log_message "ℹ️  $SERVICE_NAME is running normally (PID: $CURRENT_PID)."
else
    start_service
fi
