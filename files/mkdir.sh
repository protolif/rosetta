#!/bin/bash
# Lumanox REST API create folder test
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
FOLDER="mkdir-test"

# MKDIR API
curl -vi -X PUT \
     --data-raw "name=${FOLDER}" \
     "https://${KEY}:${SECRET}@${DOMAIN}/api/2/path/oper/mkdir/${FOLDER}"
