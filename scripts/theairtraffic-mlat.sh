#!/bin/bash

if grep -qs -e 'LATITUDE' /boot/theairtraffic-config.txt &>/dev/null && [[ -f /boot/theairtraffic-env ]]; then
    source /boot/theairtraffic-config.txt
    source /boot/theairtraffic-env
else
    source /etc/default/theairtraffic
fi

if [[ "$LATITUDE" == 0 ]] || [[ "$LONGITUDE" == 0 ]] || [[ "$USER" == 0 ]] || [[ "$USER" == "disable" ]]; then
    echo MLAT DISABLED
    sleep 3600
    exit
fi

INPUT_IP=$(echo $INPUT | cut -d: -f1)
INPUT_PORT=$(echo $INPUT | cut -d: -f2)

sleep 2

while ! nc -z "$INPUT_IP" "$INPUT_PORT" && command -v nc &>/dev/null; do
    echo "Could not connect to $INPUT_IP:$INPUT_PORT, retry in 10 seconds."
    sleep 10
done

exec /usr/local/share/theairtraffic/venv/bin/mlat-client \
    --input-type "$INPUT_TYPE" --no-udp \
    --input-connect "$INPUT" \
    --server "$MLATSERVER" \
    --user "$USER" \
    --lat "$LATITUDE" \
    --lon "$LONGITUDE" \
    --alt "$ALTITUDE" \
    $PRIVACY \
    $UUID_FILE \
    $RESULTS $RESULTS1 $RESULTS2 $RESULTS3 $RESULTS4
