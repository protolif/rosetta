#!/bin/bash
# Lumanox REST API download test
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
FOLDER="test_files"
FILE="test.docx"

curl "https://${KEY}:${SECRET}@${DOMAIN}/api/3/path/data/${FOLDER}/${FILE}" \
  -o "data/${FILE}"
