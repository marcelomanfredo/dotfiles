#!/bin/sh

monitor1=DP-1
monitor2=HDMI-A-1
timer=10800
#timer=10

magick ~/.config/hypr/wallpapers/The_Witcher/Geralt_TW3.jpg -blur 0x20 ~/.cache/wal/blurred-wp.jpg

while true; do
    wallpaper1="$(find -L ~/.config/hypr/wallpapers -type f | shuf -n 1)"
    wallpaper2="$(find -L ~/.config/hypr/wallpapers -type f | shuf -n 1)"

    hyprctl hyprpaper preload "$wallpaper1"
    hyprctl hyprpaper preload "$wallpaper2"

    hyprctl hyprpaper wallpaper "$monitor1,$wallpaper1"
    hyprctl hyprpaper wallpaper "$monitor2,$wallpaper2"

    magick $wallpaper1 -blur 0x20 ~/.cache/wal/blurred-wp.jpg
    
    wal -i $wallpaper2 -n
    cp ~/.cache/wal/colors-waybar.css ~/.cache/wal/colors-waybar-m2.css 

    wal -i $wallpaper1 -n
    cp ~/.cache/wal/colors-waybar.css ~/.cache/wal/colors-waybar-m1.css
    ~/.config/hypr/scripts/create_colors.sh ~/.cache/wal/colors.json ~/.cache/wal/colors-hyprland.conf
    
    sleep 2

    ~/.config/waybar/launch.sh

    sleep $timer

    hyprctl hyprpaper unload all

done
