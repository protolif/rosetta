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
# Intentionally using /api/2.1/path/info as it is unpaginated
list_files_in () {
	local folder=$1
	files=$(curl -sS -u "${KEY}:${SECRET}" \
	  "https://${DOMAIN}/api/2.1/path/info${folder}/?children=true&format=json" | \
	  jq -r '.children[] | select(.isfile == true).name')
}
#
list_subdirectories_in () {
	local folder=$1
	subdirectories=$(curl -sS -u "${KEY}:${SECRET}" \
	  "https://${DOMAIN}/api/2.1/path/info${folder}/?children=true&format=json" | \
	  jq -r '.children[] | select(.isdir == true).name')
}
#
checksum_file () {
	local le_path=$1
	# Request Checksum, get task URL
	local task_url=$(curl -v -X POST \
						  -u "${KEY}:${SECRET}" \
						  "https://${DOMAIN}/api/2/path/oper/checksum/" \
						  -D "data/${DOMAIN}.checksum.headers.txt" \
		 				  -d "path=${le_path}" \
						  -d "algorithm=SHA512" | \
				   jq -r '.url')
	# echo "Task URL: ${task_url}"
	# read -p "Press enter to continue"
	#
	sleep 2
	# Poll task URL and retry if it's not ready
	local query=".result.result.checksums.\""${le_path}"\""
	# echo "Query: ${query}"
	# read -p "Press enter to continue"
	local checksum=$(curl -v -u "${KEY}:${SECRET}" \
						  "https://${DOMAIN}${task_url}" \
						  -D "data/${DOMAIN}.task.headers.txt" \
		    			  --max-time 120 \
		    			  --retry 60 \
		    			  --retry-delay 2 \
		    			  --retry-max-time 120 \
		    			  --retry-all-errors | \
				   jq -r $query)
	# echo "Checksum: ${checksum}"
	# read -p "Press enter to continue"
	# Write checksum to file attributes
	curl -v -X POST -u "${KEY}:${SECRET}" \
		 -d "attributes=SHA512=${checksum}" \
		 "https://${DOMAIN}/api/2/path/info${le_path}"
}
#
checksum_all_files_in () {
	local folder=$1
	# get files from directory listing
	list_files_in "${folder}"
	if [[ -n "$files" ]]
	then
		for file in $files; do
			# echo "${folder}/${file}"
			checksum_file "${folder}/${file}"
		done
	fi
	list_subdirectories_in "${folder}"
	# loop until there are no more subdirectories to crawl
	if [[ -n "$subdirectories" ]]
	then
		for subdirectory in $subdirectories; do
			# echo "${folder}/${subdirectory}"
			checksum_all_files_in "${folder}/${subdirectory}"
		done
	fi
}
#
checksum_site () {
	checksum_all_files_in "/"
}
checksum_site
# TODO: Optimize login request via cookie jar viz activity_v3_export
# TODO: URLencode folder and file names to prevent errors e.g. te&st.jpg
