local M = {
	terminal = "ghostty",
	browser = "firefox",
	discord = "discord",
	steam = "steam",
	menu = "wofi --show",
	cliphist = "cliphist list | wofi --dmenu | cliphist decode | wl-copy",
	gimp = "gimp",
	calc = "qalculate-gtk",
	sql = "dbeaver",
	obs = "obs",
	dolphin = "dolphin",
	audio = 'pactl move-sink-input "$(pactl -f json list sink-inputs | jq -r \'.[] | "\\(.index)\\t\\(.properties["media.name"])"\' | wofi --dmenu | awk \'{print $1}\')" "$(pactl -f json list sinks | jq -r \'.[] | "\\(.index)\\t\\(.description)"\' | wofi --dmenu | awk \'{print $1}\')"',
}

return M
