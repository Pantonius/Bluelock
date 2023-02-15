#!/bin/bash

bt_addr=$1 # <your bluetooth device address>
bt_threshold=$2 # <your threshold value>
locked=false

if [ -z $bt_addr ]; then
    echo "Scanning for devices..."
    devices=$(stdbuf -oL hcitool scan | grep -v "Scanning" | nl)
    echo "$devices"
    echo "Which device do you want to use for bluelock?"
    read answer
    bt_addr=$(echo "$devices" | grep -E "^[ ]*$answer" | sed -r 's/.*(([A-F0-9]{2}:){5}[A-F0-9]{2}).*/\1/g')

    bluetoothctl trust $bt_addr
    bluetoothctl connect $bt_addr
fi

if [ -z $bt_threshold ]; then
    bt_threshold=5
fi

while true; do
    res=$(hcitool rssi $bt_addr)
    rssi=$(echo $res | sed -r 's/(.*([0-9]+))/\2/g')

    if [ -z $rssi ] && [ $locked != true ]; then
        echo Device not connected!
    else
        printf "\r%b" "RSSI is $rssi"
        if [ $rssi -gt $bt_threshold ] && [ $locked != true ]; then
            locked=true
            $(xdg-screensaver lock)
        elif [ $rssi -lt $bt_threshold ] && [ $locked == true ]; then
            locked=false
            $(loginctl unlock-session)
        fi
    fi

    sleep 1
done