#!/bin/bash
# Lumanox REST API activity export
DOMAIN="$PROD_HOSTNAME"
# REST API documentation: https://$DOMAIN/api
#
# Import secrets from Environment Variables
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
#
# Date Range
START_ON="2022-01-01"
END_ON="2022-01-02"
#
# Limit search to a specific folder of interest
# WARNING: NEVER USE PATH AS A VARIABLE
# LE_PATH="/Clients/example"
#
# Pagination
# If you are getting 403/503 error responses,
# Decrease the limit and increase pages
LIMIT="1000"
PAGES="20"

# Output file path prefix
FILE_PREFIX="data/${DOMAIN}.activity_from_${START_ON}_to_${END_ON}"

# Call the v2 API via curl
# curl documentation: https://curl.se/docs/manpage.html
curl -v -u "${KEY}:${SECRET}" \
  --max-time 120 \
  --retry 10 \
  --retry-delay 90 \
  --retry-max-time 120 \
  --retry-all-errors \
  "https://${DOMAIN}/api/2/activity/?timestamp_min=${START_ON}&timestamp_max=${END_ON}&limit=${LIMIT}&page=[1-${PAGES}]&format=csv" \
  --output "${FILE_PREFIX}_page_#1.csv"

# Combine all pages into a single file
cat $FILE_PREFIX* >> "${FILE_PREFIX}_combined.csv"

# Search
# curl -v --http1.1 "https://${KEY}:${SECRET}@${DOMAIN}/api/2/activity/?timestamp_min=${START_ON}&timestamp_max=${END_ON}&path=${LE_PATH}&limit=${LIMIT}"
