#!/bin/bash
DOMAIN="$PROD_HOSTNAME"
KEY="$PROD_API_KEY"
SECRET="$PROD_API_SECRET"
TARGET="goodbyegroup"
curl -X DELETE -u "$KEY:$SECRET" "https://$DOMAIN/api/2/group/$TARGET/"
