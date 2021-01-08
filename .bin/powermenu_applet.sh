#!/usr/bin/env bash

theme="powermenu"
dir="$HOME/.config/rofi/applets"

uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -theme $dir/$theme"

# Options
shutdown=""
reboot=""
lock=""
suspend=""
logout=""

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
		systemctl poweroff
        ;;
    $reboot)
		systemctl reboot
        ;;
    $lock)
		i3lock-fancy -f Hack Nerd -- scrot -2 ;;
    $suspend)
		systemctl suspend
        ;;
    $logout)
		bspc quit
        ;;
esac
