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
authenticate_and_save_session_id () {
	# Using session API to authenticate
	# Using basic authentication to get a cookie
	# Store it in the cookie jar
	curl -v -X POST -u "${KEY}:${SECRET}" \
		 -c "data/${DOMAIN}.session.cookie.jar.txt" \
		 -D "data/${DOMAIN}.session.headers.txt" \
			"https://${DOMAIN}/api/2/session/"
}
# jq can also be used to urlencode strings,
# which is lucky because curl can't encode the base url, only the data
escape_path () {
	escaped_path=$(printf %s $1 | jq -sRr @uri)
}
# Intentionally using /api/2.1/path/info as it is unpaginated
list_files_in () {
	escape_path $1
	files=$(curl -sS -b "data/${DOMAIN}.session.cookie.jar.txt" \
	  "https://${DOMAIN}/api/2.1/path/info${escaped_path}/?children=true&format=json" | \
	  jq -r '.children[] | select(.isfile == true).name')
}
#
list_subdirectories_in () {
	escape_path $1
	subdirectories=$(curl -sS -b "data/${DOMAIN}.session.cookie.jar.txt" \
	  "https://${DOMAIN}/api/2.1/path/info${escaped_path}/?children=true&format=json" | \
	  jq -r '.children[] | select(.isdir == true).name')
}
#
checksum_file () {
	escape_path $1
	# Request Checksum, get task URL
	local task_url=$(curl -v -X POST \
						  -b "data/${DOMAIN}.session.cookie.jar.txt" \
						  "https://${DOMAIN}/api/2/path/oper/checksum/" \
						  -D "data/${DOMAIN}.checksum.headers.txt" \
		 				  -d "path=${escaped_path}" \
						  -d "algorithm=SHA512" | \
				   jq -r '.url')
	# echo "Task URL: ${task_url}"
	# read -p "Press enter to continue"
	#
	sleep 2
	# Poll task URL and retry if it's not ready
	local query=".result.result.checksums.\""${escaped_path}"\""
	# echo "Query: ${query}"
	# read -p "Press enter to continue"
	local checksum=$(curl -v \
						  -b "data/${DOMAIN}.session.cookie.jar.txt" \
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
	curl -v -X POST \
		 -b "data/${DOMAIN}.session.cookie.jar.txt" \
		 -d "attributes=SHA512=${checksum}" \
		 "https://${DOMAIN}/api/2/path/info${escaped_path}"
}
#
checksum_all_files_in () {
	escape_path $1
	# get files from directory listing
	list_files_in "${escaped_path}"
	if [[ -n "$files" ]]; then
		for file in $files; do
			local escaped_path1 = $escaped_path
			escape_path $file
			local escaped_file1 = $escaped_path
			# echo "${escaped_path1}/${escaped_file1}"
			checksum_file "${escaped_path1}/${escaped_file1}"
		done
	fi
	list_subdirectories_in "${escaped_path}"
	# loop until there are no more subdirectories to crawl
	if [[ -n "$subdirectories" ]]; then
		for subdirectory in $subdirectories; do
			local escaped_path1 = $escaped_path
			escape_path $subdirectory
			local escaped_path2 = $escaped_path
			# echo "${escaped_path1}/${escaped_path2}"
			checksum_all_files_in "${escaped_path1}/${escaped_path2}"
		done
	fi
}
#
checksum_site () {
	checksum_all_files_in "/"
}
authenticate_and_save_session_id
checksum_site
