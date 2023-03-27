A collection of shell scripts for demonstration purposes from performing simple and complex file transfer automations, user management, and related tasks using the [Lumanox REST API][1].

It is intended to serve as a baseline for developers wanting to implement their own API integrations or a full client in any language.

Dependencies:

1. [Bash][2] or [git-bash][3] command line interpreter for shell script execution
1. [cURL][4] for making HTTPS requests to the various API endpoints
1. [jq][5] for parsing JSON responses into a usable list or array

Conventions used in this repo:

1. The [server address or hostname][6] as well as API credentials are configured to be loaded from environment variables instead of hard coded into the script:

		PROD_DOMAIN
		PROD_API_KEY
		PROD_API_SECRET
1. External files are stored in the data subdirectory relative to each script. 
	1. These directories are ignored by git in order to prevent any PII from being committed by mistake
	1. This also helps to keep folders clean and maintainable
	1. This is a convenient place to mount other fileystems or symlink local directories 
1. Output file names should begin with the [server address or hostname][6]
1. Output HTTP Headers for debugging 5XX errors, see x-unique-id
1. Readability > Esoteric Performance Gains
	1. Try to keep each line to 100 characters, escaping with backslash \

[1]: https://help.filesharing.guru/connection-methods/api-access
[2]: https://www.gnu.org/software/bash/manual/bash.html
[3]: https://gitforwindows.org
[4]: https://curl.se
[5]: https://stedolan.github.io/jq/
[6]: https://help.filesharing.guru/faq/server-address
