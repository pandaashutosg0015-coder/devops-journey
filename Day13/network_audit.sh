#!/bin/bash

TARGET_HOST="google.com"
API_ENDPOINT="https://httpbin.org/status/200"

echo "=========================================="
echo "       NETWORK CONNECTIVITY AUDIT         "
echo "=========================================="

# 1. Check DNS Resolution
echo "🔍 Checking DNS resolution for: $TARGET_HOST"
if nslookup "$TARGET_HOST" > /dev/null 2>&1; then
    RESOLVED_IP=$(nslookup "$TARGET_HOST" | awk '/^Address: / { print $2 }' | tail -n 1)
    echo "✅ DNS OK: Resolved to $RESOLVED_IP"
else
    echo "❌ DNS Failure: Unable to resolve $TARGET_HOST"
fi

echo "------------------------------------------"

# 2. Check ICMP Latency
echo "📡 Checking ICMP reachability for: $TARGET_HOST"
if ping -c 1 -W 2 "$TARGET_HOST" > /dev/null 2>&1; then
    echo "✅ ICMP OK: Host is reachable"
else
    echo "❌ ICMP Failure: Packet lost or host unreachable"
fi

echo "------------------------------------------"

# 3. Check HTTP Response Code via curl
echo "🌐 Checking HTTP status code for: $API_ENDPOINT"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API_ENDPOINT")

if [ "$HTTP_CODE" -eq 200 ]; then
    echo "✅ HTTP OK: Received status $HTTP_CODE"
else
    echo "⚠️  HTTP Alert: Received status $HTTP_CODE"
fi

echo "=========================================="

