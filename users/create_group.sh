#!/bin/bash
set -B # enable brace expansion
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
for i in {1..1000}; do
  curl -X POST -d "name=hellogroup$i&users=helloworld$i" \
       -u "${KEY}:${SECRET}" \
       "https://${DOMAIN}/api/2/group/"
done
