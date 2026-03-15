#!/bin/bash

# Konfiguration (wird von Docker uebergeben)
# TOKEN=$DESEC_TOKEN
# ZONE=$DESEC_ZONE
# HOSTS=$DESEC_HOSTS

IP_FILE="/data/current_ip.txt"

while true; do
    # 1. IP ziehen
    IP=$(curl -s4 https://checkipv4.dedyn.io/)
    if [ -z "$IP" ]; then
        echo "$(date) - IP konnte nicht ermittelt werden."
        sleep 60
        continue
    fi

    # 2. Cache-Check
    if [[ -f "$IP_FILE" && "$IP" == "$(cat "$IP_FILE")" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - IP unverändert ($IP)."
    else
        # 3. Payload & Update
        # Wir nutzen jq um den HOSTS-String (JSON Array) zu verarbeiten
        PAYLOAD=$(echo "$DESEC_HOSTS" | jq -c "map({subname: ., type: \"A\", records: [\"$IP\"], ttl: 3600})")
        
        RESPONSE=$(curl -s -X PATCH "https://desec.io/api/v1/domains/$DESEC_ZONE/rrsets/" \
            -H "Authorization: Token $DESEC_TOKEN" \
            -H "Content-Type: application/json" \
            -d "$PAYLOAD")

        if [[ "$RESPONSE" == *"subname"* || "$RESPONSE" == "[]" ]]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - SUCCESS: deSEC aktualisiert auf $IP."
            echo "$IP" > "$IP_FILE"
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') - FEHLER: $RESPONSE"
        fi
    fi
    sleep 300
done
