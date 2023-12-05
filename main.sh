#!/bin/bash

cd $(dirname $0)

echo "[*] starting avahi-daemon..."
./sbin/avahi-daemon --no-rlimits --no-drop-root &
sleep 3

echo "[*] starting usbmuxd..."
./sbin/usbmuxd --debug --allow-heartless-wifi &
sleep 3

echo "[*] waiting for any device..."
while true; do
    sleep 3
    echo "[*] checking devices..."
    ./bin/idevice_id -n || true
done

