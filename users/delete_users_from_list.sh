#!/bin/bash
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
LIST="data/delete_users_list.txt"
LINES=$(cat $LIST)
for i in $LINES; do
  curl -X DELETE -u "${KEY}:${SECRET}" "https://${DOMAIN}/api/2/user/$i/"
done
