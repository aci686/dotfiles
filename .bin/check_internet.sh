#!/usr/bin/env bash

count=0
connected="說"
disconnected="ﲁ"

ID="$(ip link | awk '/state UP/ {print $2}')"

while true; do
    if (ping -c 1 archlinux.org || ping -c 1 google.com || ping -c 1 bitbucket.org || ping -c 1 github.com || ping -c 1 sourceforge.net) &>/dev/null; then
        if [[ $ID == e* ]]; then
            echo "$connected" ; sleep 25
        else
            echo "$connected" ; sleep 25
        fi
    else
        echo "$disconnected" ; sleep 5
    fi
done
