#!/bin/bash
# Lumanox REST API file attributes
# Dependencies:
# curl to make HTTPS requests, install via cli `brew install curl`
# Documentation:
# Lumanox REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
DOMAIN="$PROD_HOSTNAME"
# Import secrets from Environment Variables
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
FOLDER="/test_files"
FILE="test.pdf"
# WARNING: NEVER USE PATH AS A VARIABLE
LE_PATH="${FOLDER}/${FILE}"
# Write key value pairs to the file's attributes
curl -v -X POST -u "${KEY}:${SECRET}" \
	 -d "attributes=key1=value1" \
	 -d "attributes=key2=value2" \
	 -d "attributes=key3=value3" \
	 "https://${DOMAIN}/api/2/path/info${LE_PATH}"
