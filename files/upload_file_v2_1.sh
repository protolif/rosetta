#!/bin/bash
# Lumanox REST API upload test
# Import secrets from Environment Variables
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
FOLDER="tests/api/upload/v2.1"
# FILE="test_1gb.zip"
# MIME="application/zip"
# MIME="multipart/form-data"
# MIME="application/octet-stream"
FILE="test.txt"
MIME="text/plain"

# Streaming API
# curl -vi -X PUT \
#      -H "Transfer-Encoding: chunked" \
#      -H "Content-Type: ${MIME}" \
#      -H "X-File-Name: ${FILE}" \
#      --data-binary "@${FILE}" \
#      "https://${KEY}:${SECRET}@${DOMAIN}/api/3/path/data/${FOLDER}/${FILE}"

# Old API
curl -vi --http1.1 \
     -H "Content-Type: ${MIME}" \
     --data-binary "@${FILE}" \
     "https://${KEY}:${SECRET}@${DOMAIN}/api/2.1/path/data/${FOLDER}/"
