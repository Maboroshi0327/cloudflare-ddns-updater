#!/usr/bin/with-contenv bashio

# This script is adapted from the following sources:
# 1. Source 1: cf-ip-renew.sh - https://github.com/samejack/blog-content/blob/master/ddns/cf-ip-renew.sh (Apache 2.0 License)
# 2. Source 2: run.sh - https://github.com/kjell5317/addon-ddns/blob/main/run.sh (MIT License)
# MIT License

DNS=$(bashio::config 'DNS')
CF_TOKEN=$(bashio::config 'CF_TOKEN')
CF_ZONE_ID=$(bashio::config 'CF_ZONE_ID')
CF_RECORD_ID=$(bashio::config 'CF_RECORD_ID')
proxied=$(bashio::config 'proxied')
time=$(bashio::config 'time')

# First update IP.
IP1=$(curl -s http://ipv4.icanhazip.com)
bashio::log.info "Renew IP: ${IP1}"
curl -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${CF_RECORD_ID}" \
    -H "Authorization: Bearer ${CF_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'${DNS}'","content":"'${IP1}'","ttl":1,"proxied":'${proxied}'}' \
    | jq
sleep "${time}"

# If the public IP changes, update the IP.
while true
do
    # Check public IP
    if IP2=$(curl -s http://ipv4.icanhazip.com)
    then

        # Compare public IP and old IP
        if [ "$IP1" != "$IP2" ]
        then

            # Update IP
            if responses=$(curl -X PUT "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$CF_RECORD_ID" \
                -H "Authorization: Bearer $CF_TOKEN" \
                -H "Content-Type: application/json" \
                --data '{"type":"A","name":"'$DNS'","content":"'$IP2'","ttl":1,"proxied":'$proxied'}') \
                && [ $(echo $responses | jq -r '.success') == "true" ]
            then
                bashio::log.info "Renew IP: $IP1 to $IP2"
                IP1="$IP2"
            else
                bashio::log.error "Failed updating $DNS $(echo $responses | jq -r '.errors | .[0]')"
            fi

        # Compare public IP and old IP
        else
            bashio::log.info "No change: $IP1"
        fi
    
    # Check public IP
    else
        bashio::log.error "Unable to connect to http://ipv4.icanhazip.com to check the public IP address"
    fi

    sleep "${time}"
done
