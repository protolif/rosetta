#!/bin/bash
# Lumanox REST API upload test
DOMAIN="$PROD_HOSTNAME"
# Import secrets from Environment Variables
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# Get the current date and time
date_today=$(date '+%m-%d-%Y')
time_now=$(date '+%I.%M%p.%Z')
# Everything will be compressed into a single zip file named
FILE="download-${date_today}@${time_now}.zip"
# Folder to download
REMOTE_FOLDER="/test_files"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
curl -v --http1.1 -d "path=${REMOTE_FOLDER}" -d "filename=${FILE}" \
     "https://${KEY}:${SECRET}@${DOMAIN}/api/2/path/oper/downloadmultiple/" \
     -o "${FILE}"
