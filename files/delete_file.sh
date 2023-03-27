#!/bin/bash
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
FOLDER="/tests/api/delete/"
FILE="test['].txt"

# Delete in background job
curl -X POST -u "${KEY}:${SECRET}" "https://${DOMAIN}/api/2/path/oper/remove/" \
     --data "path=${FOLDER}${FILE}"

# Delete versions before x (error 500)
# curl -X DELETE -u "${KEY}:${SECRET}" "https://${DOMAIN}/api/2/path/data/${FOLDER}${FILE}?version=1"
