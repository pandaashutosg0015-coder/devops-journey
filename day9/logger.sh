#!/bin/bash

# Define logging functions
log_info() {
    echo "ℹ️  [INFO] $(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log_success() {
    echo "✅ [SUCCESS] $(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo "❌ [ERROR] $(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Simulate a deployment pipeline using our functions
log_info "Initiating application deployment..."

# Check if a config file exists (simulating error handling)
CONFIG_FILE="app.conf"

if [ -f "$CONFIG_FILE" ]; then
    log_success "Configuration file found. Continuing deployment."
else
    log_error "Missing $CONFIG_FILE! Halting deployment."
    exit 1
fi
