#!/bin/bash
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
LE_PATH="test_files/test.txt"
DATA="owner[first_name]=valued&owner[last_name]=customer&owner[email]=noreply@example.com&owner[name]=Valued%20Customer&owner[username]=valuedcustomer&owner[url]=/api/2.1/user/valuedcustomer/"

curl -v --http1.1 -d $DATA "https://${KEY}:${SECRET}@${DOMAIN}/api/2/path/info/${LE_PATH}"
# this is supposed to test if the file owner can be updated via API. it shouldn't.
