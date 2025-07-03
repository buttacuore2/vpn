#!/bin/bash
apt update
apt install -y jq curl 
ZONE_ID="a3e6bf07fda3ed8e56dde17376255188"
API_TOKEN="dwBIJbunVoeQ_lzgUs0VPUINO2pxFjxETij4kSb3"
RECORD_NAME="NF-$(head /dev/urandom | tr -dc a-z0-9 | head -c 5).andotv.ggff.net"
echo "Record DNS $RECORD_NAME..."
RECORD_TYPE="A"
#RECORD_CONTENT= $(curl -s ipinfo.io/ip)
RECORD_TTL=300
PROXIED="false"
API_URL="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records"
DATA='{"type":"'"$RECORD_TYPE"'", "name":"'"$RECORD_NAME"'", "content":"'"$(curl -s ipinfo.io/ip)"'", "ttl":'$RECORD_TTL', "proxied": '"$PROXIED"'}'

RECORD=$(curl -sX GET "${API_URL}?name=${RECORD_NAME}" \
     -H "Authorization: Bearer ${API_TOKEN}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
if [ "${#RECORD}" -le 10 ]; then
	curl -X POST "$API_URL" \
		 -H "Authorization: Bearer $API_TOKEN" \
		 -H "Content-Type: application/json" \
		 --data "$DATA"
fi

echo "---------------------------------------------------------------------------------------"
set -euo pipefail
echo " REponce:  $RECORD"
echo "Record DNS $RECORD_NAME..."
# Output confirmation
echo "Host: $RECORD_NAME"
echo "Done Record Domain: $RECORD_NAME for VPS"

# Update configuration files (ensure directories exist)
# Update configuration files (ensure directories exist)
echo "Script execution completed."
echo "Host : $RECORD_NAME"
echo -e "Done Record Domain= ${RECORD_NAME} For VPS"
echo "$RECORD_NAME" > /etc/domain/d-domain
echo "$RECORD_NAME" >/etc/domain/f-domain 
rm -rf cf
sleep 1
