-- Autostart

local var = require("conf.variables")

hl.on("hyprland.start", function()
	hl.exec_cmd(var.browser)
	hl.exec_cmd("mako")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd(var.terminal)
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("hyprsunset")

	-- Waybar
	hl.exec_cmd("~/.config/waybar/launch.sh")
end)
