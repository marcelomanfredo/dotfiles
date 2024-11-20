#!/bin/sh

# ----------------------------------------------
# Quit all running waybar instances
# ----------------------------------------------
killall waybar

# ----------------------------------------------
# Get monitors
# ----------------------------------------------
monitors=$(hyprctl -j monitors | jq -r '.[].name')

# ----------------------------------------------
# Run waybar with style depending on wallpaper
# ----------------------------------------------
for monitor in $monitors; do
    case "$monitor" in
	"DP-1")
		waybar -c ~/.config/waybar/custom/config-m1.jsonc -s ~/.config/waybar/custom/style-m1.css &
		;;
	"HDMI-A-1")
		waybar -c ~/.config/waybar/custom/config-m2.jsonc -s ~/.config/waybar/custom/style-m2.css &
		;;
	*)
		echo "$monitor not found."
		;;
    esac
done
