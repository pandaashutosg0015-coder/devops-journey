#!/bin/bash

ATTEMPT=1
MAX_ATTEMPTS=5

echo "Simulating service availability check..."

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    echo "Checking service status (Attempt $ATTEMPT of $MAX_ATTEMPTS)..."

    # Simulate a wait time between checks
    sleep 1

    # On attempt 4, simulate service turning healthy
    if [ $ATTEMPT -eq 4 ]; then
        echo "🎉 Service is HEALTHY and accepting connections!"
        exit 0
    fi

    echo "⏳ Service unavailable. Retrying..."
    ATTEMPT=$((ATTEMPT + 1))
done

echo "❌ Service failed to start within the timeout window."
exit 1

