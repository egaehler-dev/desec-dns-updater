#!/bin/bash

# Configuration (passed via Docker environment variables)
# DESEC_TOKEN: Your deSEC API Token
# DESEC_ZONE: Your domain 
# DESEC_HOSTS: JSON array of subdomains 

IP_FILE="/data/current_ip.txt"

while true; do
    # 1. Fetch current public IPv4
    IP=$(curl -s4 https://checkipv4.dedyn.io/)
    if [ -z "$IP" ]; then
        echo "$(date) - ERROR: Could not determine public IP."
        sleep 60
        continue
    fi

    # 2. Cache-Check (Only update if IP has changed)
    if [[ -f "$IP_FILE" && "$IP" == "$(cat "$IP_FILE")" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - IP unchanged ($IP). Skipping update."
    else
        # 3. Build Payload & Execute Update
        # Using jq to process the HOSTS JSON array
        PAYLOAD=$(echo "$DESEC_HOSTS" | jq -c "map({subname: ., type: \"A\", records: [\"$IP\"], ttl: 3600})")
        
        RESPONSE=$(curl -s -X PATCH "https://desec.io/api/v1/domains/$DESEC_ZONE/rrsets/" \
            -H "Authorization: Token $DESEC_TOKEN" \
            -H "Content-Type: application/json" \
            -d "$PAYLOAD")

        # Check if response contains success indicators
        if [[ "$RESPONSE" == *"subname"* || "$RESPONSE" == "[]" ]]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - SUCCESS: deSEC updated to $IP."
            echo "$IP" > "$IP_FILE"
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $RESPONSE"
        fi
    fi
    # Wait for 5 minutes
    sleep 300
done
