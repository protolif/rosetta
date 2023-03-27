#!/bin/bash
# Lumanox REST API create many users test
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
set -B # enable brace expansion to do ranges in for loops
for i in {1..200}; do
  username="valuedcustomer${i}"
  curl -X POST -d "name=${username}" \
               -d "username=${username}" \
               -d "role=User" \
               -d "email=${username}@example.com" \
               -d "send_email=False" \
               -d "password=correct-horse-staple-battery42$i" \
               -u "${KEY}:${SECRET}" \
               "https://${DOMAIN}/api/2/user/"
done
