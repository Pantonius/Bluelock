#!/bin/bash

bt_addr=$1 # <your bluetooth device address>
bt_threshold=$2 # <your threshold value>
locked=false

if [ -z $bt_addr ]; then
    echo "Please provide bluetooth device address"
    exit 1
fi

if [ -z $bt_threshold ]; then
    echo "Please provide rssi threshold value"
    exit 1
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