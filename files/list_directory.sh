#!/bin/bash
# Lumanox REST API list directory
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
FOLDER="/tests/archive-test/large-folder/"
curl -i -u "${KEY}:${SECRET}" "https://${DOMAIN}/api/2/path/info${FOLDER}"
