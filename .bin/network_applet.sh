#!/usr/bin/env bash

dir="$HOME/.config/rofi/applets/"
rofi_command="rofi -theme $dir/network.rasi"

## Get info
IFACE="$(nmcli | grep -i interface | awk '/interface/ {print $2}')"
#SSID="$(iwgetid -r)"
#LIP="$(nmcli | grep -i server | awk '/server/ {print $2}')"
#PIP="$(dig +short myip.opendns.com @resolver1.opendns.com )"
STATUS="$(nmcli radio wifi)"

active=""
urgent=""

if (ping -c 1 debian.org || ping -c 1 google.com || ping -c 1 github.com || ping -c 1 sourceforge.net) &>/dev/null; then

	if [[ $STATUS == *"enable"* ]]; then
        if [[ $IFACE == e* ]]; then
            connected=""
        else
            connected=""
        fi
	active="-a 0"
	SSID="﬉ $(iwgetid -r); IP: $(wget --timeout=30 http://ipinfo.io/ip -qO -)"
	fi
else
    urgent="-u 0"
    SSID="Disconnected; IP: Not Available"
    connected=""
fi

## Icons
bmon=""
launch_cli=""
launch=""

options="$connected\n$bmon\n$launch_cli\n$launch"

## Main
chosen="$(echo -e "$options" | $rofi_command -p "$SSID" -dmenu $active $urgent -selected-row 1)"
case $chosen in
    $connected)
		if [[ $STATUS == *"enable"* ]]; then
			nmcli radio wifi off
		else
			nmcli radio wifi on
		fi 
        ;;
    $bmon)
        terminator -e bmon
        ;;
    $launch_cli)
        terminator -e nmtui
        ;;
    $launch)
        nm-connection-editor
        ;;
esac

