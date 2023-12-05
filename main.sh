#!/bin/bash

set -ex

cd $(dirname $0)
./sbin/usbmuxd --debug --allow-heartless-wifi &

while true; do
    echo "[*] waiting for any device..."
    ./bin/idevice_id -n
    if [ $? -eq 0 ]; then
        echo "[*] device connected"
        break
    fi
    sleep 3
done

echo "[*] test done"
