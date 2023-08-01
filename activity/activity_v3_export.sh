#!/bin/bash
# Lumanox REST API activity v3 export
DOMAIN="$PROD_HOSTNAME"
# REST API documentation: https://$DOMAIN/api
# Import secrets from Environment Variables
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# Date Range
START_ON="2023-07-01"
END_ON="2023-07-30"
# Filter by folder or file name (or other keywords)
# Note: Spaces and other special characters need to be URL encoded
FOLDER="/clients/smith"
# Export file format (Options: csv, tsv, json, xml)
FORMAT="csv"
# Using session API with basic authentication to get a cookie
# Store it in the cookie jar
# curl documentation: https://curl.se/docs/manpage.html
curl -v -X POST -u "${KEY}:${SECRET}" \
   -c "data/${DOMAIN}.session.cookie.jar.txt" \
   -D "data/${DOMAIN}.session.headers.txt" \
      "https://${DOMAIN}/api/2/session/"
# Fields:
# Specify the columns you want as fields[]
# use brackets for array fields, but escape them
# because they are interpreted by curl as a sequence
DRY="&fields\[\]="
# Declare String Array. If you want more fields, add them here:
declare -a fields=( \
  timestamp user_name user_username type action result conn_type obj0_name ip_addr size country_name \
)
# Declare an empty string to be assembled in the for loop
my_fields=""
for field in "${fields[@]}"; do
  my_fields+="$DRY$field"
done
# my fields are dry fields
#
# Misc strings to tidy the next request
AM="%2000:00:01&"
PM="%2023:59:59"
t="timestamp\[\]="
e="/api/3/activity/export/"
k="keyword=${FOLDER}"
# Request Activity Export (session cookie auth)
curl -v -b "data/${DOMAIN}.session.cookie.jar.txt" \
     -D "data/${DOMAIN}.export.headers.txt" \
     "https://${DOMAIN}$e?$k&$t>=${START_ON}${AM}$t<=${END_ON}${PM}${my_fields}&format=${FORMAT}" \
     --max-time 120 \
     --retry 10 \
     --retry-delay 90 \
     --retry-max-time 120 \
     --retry-all-errors \
     --output "data/${DOMAIN}.activity_from_${START_ON}_to_${END_ON}.${FORMAT}"
