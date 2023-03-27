#!/bin/bash
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
set -B # enable brace expansion
for i in {1..200}; do
  curl -X DELETE -u "${KEY}:${SECRET}" "https://${DOMAIN}/api/2/user/valuedcustomer$i/"
done
