#!/bin/bash
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
OLD_USERNAME="helloworld999a"
NEW_USERNAME="helloworld999b"

curl -v --http1.1 -d "username=${NEW_USERNAME}" \
     "https://${KEY}:${SECRET}@${DOMAIN}/api/2/user/${OLD_USERNAME}/"
