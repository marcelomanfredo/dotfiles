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
}

return M
