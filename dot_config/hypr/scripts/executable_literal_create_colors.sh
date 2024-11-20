#!/bin/bash

if [[ $# -lt 2 ]]; then
	echo "Usage: $0 /path/to/colors.json /path/to/colors-hyprland.conf [alpha_value]"
	exit 1
fi

colors_file="$1"
output_file="$2"
alpha_value="${3:-E6}"
# Alpha = 0 (fully transparent): 00
# Alpha = 0.5 (50% transparent): 80
# Alpha = 1 (fully opaque): FF

if [[ ! -f "$colors_file" ]]; then
    echo "Error: $colors_file not found!"
    exit 1
fi

hex_to_rgba() {
    local hex="$1"
    hex="${hex//\"/}"  # Remove any quotes around the hex color
    hex="${hex#\#}"    # Remove the leading '#'
    if [[ ${#hex} -eq 6 ]]; then
        local r="${hex:0:2}"
        local g="${hex:2:2}"
        local b="${hex:4:2}"
	printf "rgb(%d, %d, %d, %d)\n" "$((16#$r))" "$((16#$g))" "$((16#$b))" "$((16#$alpha_value))"
    else
        echo "Invalid hex color: $hex"
    fi
}

hex_to_rgba_format() {
	local hex="$1"
	hex="${hex//\"/}"
	hex="${hex#\#}"
	echo "rgba($hex$alpha_value)"
}

hex_to_rgb_format() {
	local hex="$1"
	hex="${hex//\"/}"
	hex="${hex#\#}"
	echo "rgba("$hex"FF)" #colors from 20 to 35 should be equal to 0 to 15, but with full opacity
}

counter=20
{
	jq -r '.special | to_entries[] | "\(.key):\(.value)"' "$colors_file" | while IFS=":" read -r name hex; do
		rgba=$(hex_to_rgba_format "$hex")
		echo "\$$name = $rgba"
	done

	jq -r '.colors | to_entries[] | "\(.key):\(.value)"' "$colors_file" | while IFS=":" read -r name hex; do
		rgba=$(hex_to_rgba_format "$hex")
		rgb=$(hex_to_rgb_format "$hex")
		echo "\$$name = $rgba"
		echo "\$color$counter = $rgb"
		((counter++))
	done
} > $output_file

echo "RGB() values from $1 successfully written to $2! [Alpha of $alpha_value]"
