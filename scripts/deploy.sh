#!/bin/bash
AUTH=$1
FINAL_URL=$2
PAYLOAD=$3

echo "=== Dummy Deploy Script ==="
echo "Auth: $AUTH"
echo "URL: $FINAL_URL"
echo "Payload file: $PAYLOAD"

# Simulasi POST request ke mock API (httpbin.org)
curl -X POST "$FINAL_URL" \
    -H "Authorization: Basic $AUTH" \
    -H "Content-Type: application/json" \
    -d @"$PAYLOAD"
