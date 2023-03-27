#!/bin/bash
# Lumanox REST API webhook registration
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
CALLBACK_URL="https://www.example.com/callback"

curl -X POST -d "event=file.uploaded" \
     --data-urlencode "target=${CALLBACK_URL}" \
     -u "${KEY}:${SECRET}" \
     "https://${DOMAIN}/api/3/webhook/"
