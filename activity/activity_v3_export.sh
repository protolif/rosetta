#!/bin/bash
# Lumanox REST API activity v3 export
DOMAIN="$PROD_HOSTNAME"
# REST API documentation: https://$DOMAIN/api
# Import secrets from Environment Variables
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# Date Range
START_ON="2023-03-01"
END_ON="2023-03-30"
# Export file format
FORMAT="csv"
# Pagination
# Is not supported in the export endpoint, but is fast enough to not need to.
# ["query should NOT have additional properties 'limit'","query should NOT have additional properties 'offset'"]
#
# Output file path prefix
FILE_PREFIX="data/${DOMAIN}.activity_from_${START_ON}_to_${END_ON}"
#
# Specify the columns you want as fields[]
# use brackets for array fields, but escape them
# because they are interpreted by curl as a sequence
DRY="&fields\[\]="
# Declare String Array. If you want more fields, add them here:
declare -a fields=( timestamp user_name user_username type action result conn_type ip_addr size country_name )
# Declare an empty string to be assembled in the for loop
my_fields=""
for field in "${fields[@]}"; do
	my_fields+="$DRY$field"
done
# my fields are dry fields
#
# Call the v3 API via curl
# curl documentation: https://curl.se/docs/manpage.html
# Using session API to authenticate
# Using basic authentication to get a cookie
# Store it in the cookie jar
curl -v -X POST -u "${KEY}:${SECRET}" \
	 -c "data/${DOMAIN}.session.cookie.jar.txt" \
	 -D "data/${DOMAIN}.session.headers.txt" \
		"https://${DOMAIN}/api/2/session/"
# Read sessionid from cookie jar
# Request Activity Export
curl -v -b "data/${DOMAIN}.session.cookie.jar.txt" \
	 -D "data/${DOMAIN}.export.headers.txt" \
	 "https://${DOMAIN}/api/3/activity/export/?timestamp\[\]=>=${START_ON}%2000:00:01&timestamp\[\]=<=${END_ON}%2023:59:59${my_fields}&format=${FORMAT}" \
     --max-time 120 \
     --retry 10 \
     --retry-delay 90 \
     --retry-max-time 120 \
	 --retry-all-errors \
	 --output "${FILE_PREFIX}.${FORMAT}"
