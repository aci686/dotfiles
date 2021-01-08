#!/usr/bin/env bash

dir="$HOME/.config/rofi/applets/"
rofi_command="rofi -theme $dir/launcher.rasi"

# Links
terminal=""
files=""
editor=""
browser=""
music=""
settings=""

# Error msg
msg() {
	rofi -theme "$HOME/.config/rofi/styles/message.rasi" -e "$1"
}

# Variable passed to rofi
options="$terminal\n$files\n$editor\n$browser\n$music\n$settings"

chosen="$(echo -e "$options" | $rofi_command -p "Most Used" -dmenu -selected-row 0)"
case $chosen in
    $terminal)
		if [[ -f /usr/bin/terminator ]]; then
			terminator &
		elif [[ -f /usr/bin/xterm ]]; then
			xterm &
		else
			msg "No suitable terminal found!"
		fi
        ;;
    $files)
		if [[ -f /usr/bin/nemo ]]; then
			nemo &
		else
			msg "No suitable file manager found!"
		fi
        ;;
    $editor)
		if [[ -f /usr/bin/code ]]; then
			code &
		else
			msg "No suitable text editor found!"
		fi
        ;;
    $browser)
		if [[ -f /usr/bin/firefox ]]; then
			firefox &
		else
			msg "No suitable web browser found!"
		fi
        ;;
    $music)
		if [[ -f /usr/bin/lxmusic ]]; then
			lxmusic &
		else
			msg "No suitable music player found!"
		fi
        ;;
    $settings)
		if [[ -f /usr/bin/xfce4-settings-manager ]]; then
			xfce4-settings-manager &
		else
			msg "No suitable settings manager found!"
		fi
        ;;
esac
