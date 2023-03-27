#!/bin/bash
# Lumanox REST API list users
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
curl -u "${KEY}:${SECRET}" "https://${DOMAIN}/api/2/user/"
