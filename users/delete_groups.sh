#!/bin/bash
# Lumanox REST API group mass delete
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
set -B # enable brace expansion
for i in {1..1000}; do
  curl -X DELETE -u "${KEY}:${SECRET}" "https://${DOMAIN}/api/2/group/hellogroup$i/"
done
