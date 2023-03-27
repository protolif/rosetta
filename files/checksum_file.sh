#!/bin/bash
# Lumanox REST API file checksum
# Dependencies:
# curl to make HTTPS requests, install via cli `brew install curl`
# jq to parse JSON, install via cli `brew install jq`
# Documentation:
# Lumanox REST API documentation: https://$DOMAIN/api
# curl documentation: https://curl.se/docs/manpage.html
# jq documentation: https://stedolan.github.io/jq/manual/
DOMAIN="$PROD_HOSTNAME"
# Import secrets from Environment Variables
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
FOLDER="/test_files"
FILE="test.pdf"
LE_PATH="${FOLDER}/${FILE}"
# Request Checksum, get task URL
TASK_URL=$(curl -v -X POST \
				-u "${KEY}:${SECRET}" \
				"https://${DOMAIN}/api/2/path/oper/checksum/" \
				-D "data/${DOMAIN}.checksum.headers.txt" \
 				-d "path=${LE_PATH}" \
				-d "algorithm=SHA512" | \
		 jq -r '.url')
# echo "Task URL: ${TASK_URL}"
# read -p "Press enter to continue"
#
sleep 2
# Poll task URL and retry if it's not ready
QUERY=".result.result.checksums.\""${LE_PATH}"\""
# echo "Query: ${QUERY}"
# read -p "Press enter to continue"
CHECKSUM=$(curl -v -u "${KEY}:${SECRET}" \
				"https://${DOMAIN}${TASK_URL}" \
				-D "data/${DOMAIN}.task.headers.txt" \
    			--max-time 120 \
    			--retry 60 \
    			--retry-delay 2 \
    			--retry-max-time 120 \
    			--retry-all-errors | \
		 jq -r $QUERY)
echo "Checksum: ${CHECKSUM}"
