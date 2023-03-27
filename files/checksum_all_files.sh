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
# get files from directory listing
FILENAMES=$(curl -sS -u "${KEY}:${SECRET}" \
  "https://${DOMAIN}/api/2.1/path/info${FOLDER}/?children=true&format=json" | \
  jq -r '.children[] | select(.isfile == true).name')
# echo "${FILENAMES}"
for FILE in $FILENAMES; do
	#
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
	# echo "Checksum: ${CHECKSUM}"
	# read -p "Press enter to continue"
	# Write checksum to file attributes
	curl -v -X POST -u "${KEY}:${SECRET}" \
		 -d "attributes=SHA512=${CHECKSUM}" \
		 "https://${DOMAIN}/api/2/path/info${LE_PATH}"
done
# TODO: Refactor this into a function
# TODO: Implement recursion
# To get only subfolders
# query simliar to FILENAMES but where .isdir == true
