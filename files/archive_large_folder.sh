#!/bin/bash
# Lumanox REST API archive large folder
# Dependencies:
# curl to make HTTPS requests, install via cli `brew install curl`
# jq to parse JSON, install via cli `brew install jq`
# Documentation:
# Lumanox REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
# jq documentation: https://stedolan.github.io/jq/manual/
# Load host and credentials from environment:
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
# Max folder size before listing timeouts occur. Default is 500
MAX_FOLDER_SIZE=500
# Full path to the large folder needing to be archived. Leave a trailing slash.
SOURCE_FOLDER="/tests/large-folder/"
# In the event this script is interrupted, or otherwise more files remain
# Set this value to the last archive folder number, default is 0
RESTART_TALLY=0
# fetch the item count from API
ITEMS=$(curl -sS -u "${KEY}:${SECRET}" \
  "https://${DOMAIN}/api/2/path/info${SOURCE_FOLDER}?format=json" | \
  jq '.items')
echo "total items: ${ITEMS}"
# Validate ITEMS is a number
if ! (( $ITEMS % 1 )); then
  # Divide by MAX_FOLDER_SIZE and add 1 for the total number of subfolders needed
  FOLDERS_NEEDED=$(((( $ITEMS / $MAX_FOLDER_SIZE )) + 1))
  # Create that many directories, plus 1 for the remainder
  for i in $(seq 1 $FOLDERS_NEEDED); do
    folder_number=$(($i + $RESTART_TALLY))
    curl -sS -X PUT \
      --data-raw "name=${SOURCE_FOLDER}" \
      "https://${KEY}:${SECRET}@${DOMAIN}/api/2/path/oper/mkdir${SOURCE_FOLDER}archive${folder_number}"
    # pause for directory to actually be created on disk
    sleep 1
    echo "..."
    # get the next 500 files from directory listing
    FILENAMES=$(curl -sS -u "${KEY}:${SECRET}" \
      "https://${DOMAIN}/api/2/path/info${SOURCE_FOLDER}?children=true&limit=${MAX_FOLDER_SIZE}&page=1&format=json" | \
      jq -r '.children[]?.name')
    for x in $FILENAMES; do
      # echo "Folder ${folder_number} of ${FOLDERS_NEEDED}, File ${i}: Filename: ${x}"
      # rename... unless it starts with "archive"
      if [[ $x = \archive* ]] ; then
        echo "skipping archive folder..."
      else
        echo "archiving... ${x}"
        curl "https://${KEY}:${SECRET}@${DOMAIN}/api/2/path/oper/rename/" \
          --data-raw "src=${SOURCE_FOLDER}${x}&dst=${SOURCE_FOLDER}archive${folder_number}/${x}" \
          --max-time 120 \
          --retry 10 \
          --retry-delay 90 \
          --retry-max-time 120 \
   	      --retry-all-errors
      fi
    done
  done
else
  echo "items is not a number divisible by 1."
fi
