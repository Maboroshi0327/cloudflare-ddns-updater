#!/usr/bin/with-contenv bashio

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
    IP2=$(curl -s http://ipv4.icanhazip.com)
    if [ "$IP1" != "$IP2" ]
    then
        bashio::log.info "Renew IP: ${IP1} to ${IP2}"
        
        curl -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${CF_RECORD_ID}" \
            -H "Authorization: Bearer ${CF_TOKEN}" \
            -H "Content-Type: application/json" \
            --data '{"type":"A","name":"'${DNS}'","content":"'${IP2}'","ttl":1,"proxied":'${proxied}'}' \
            | jq
        IP1="$IP2"
    else
        bashio::log.info "No change: ${IP1}"
    fi

    sleep "${time}"
done