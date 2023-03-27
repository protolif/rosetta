#!/bin/bash
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
FILENAME="delete_users_list.csv"

while IFS=, read -r foo bar username baz qux etc; do
  # echo "Deleting ${username}"
  curl -X DELETE -u "${KEY}:${SECRET}" "https://${DOMAIN}/api/2/user/${username}/"
done < $FILENAME