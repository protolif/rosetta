#!/bin/bash
# Lumanox REST API upload test
# Import secrets from Environment Variables
DOMAIN="$BETA_HOSTNAME"
KEY="$BETA_API_KEY"
SECRET="$BETA_API_SECRET"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
FOLDER="tests/api/upload/v2.2"
# FILE="test_1gb.zip"
# MIME="application/zip"
# MIME="multipart/form-data"
# MIME="application/octet-stream"
FILE="test.txt"
MIME="application/binary"

curl -vi --http1.1 \
     -H "Content-Type: ${MIME}" \
     --data-binary "@${FILE}" \
     "https://${KEY}:${SECRET}@${DOMAIN}/api/2/path/data/${FOLDER}/"
