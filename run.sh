#!/usr/bin/with-contenv bashio

DNS=$(bashio::config 'DNS')
CF_TOKEN=$(bashio::config 'CF_TOKEN')
CF_ZONE_ID=$(bashio::config 'CF_ZONE_ID')
CF_RECORD_ID=$(bashio::config 'CF_RECORD_ID')
proxied=$(bashio::config 'proxied')
time=$(bashio::config 'time')


while true
do
    INTERNET_IP=`curl -s http://ipv4.icanhazip.com`
    DNS_RECORD_IP=`dig ${DNS} | grep "${DNS}" | grep -v ';' | awk '{print$5}'`

    bashio::log.info "Renew IP: ${DNS_RECORD_IP} to ${INTERNET_IP}"
    curl -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${CF_RECORD_ID}" \
        -H "Authorization: Bearer ${CF_TOKEN}" \
        -H "Content-Type: application/json" \
        --data '{"type":"A","name":"'${DNS}'","content":"'${INTERNET_IP}'","ttl":120,"proxied":'${proxied}'}'
    sleep "${time}"
done