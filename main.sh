#!/bin/bash

cd $(dirname $0)
./sbin/usbmuxd --debug --allow-heartless-wifi &

while true; do
    echo "[*] waiting for any device..."
    ./bin/idevice_id -n || true
    sleep 3
done

echo "[*] test done"
