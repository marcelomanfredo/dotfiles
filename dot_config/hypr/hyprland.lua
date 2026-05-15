------------------------------
---------- Monitors ----------
------------------------------

hl.monitor({
	output = "DP-1",
	mode = "1920x1080@144",
	position = "0x0",
	scale = "1",
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@75",
	position = "1920x0",
	scale = "1",
})

------------------------------
------------ Envs ------------
------------------------------
hl.env("xcursor_size", "10")
hl.env("hyprcursor_size", "10")
hl.env("GTK_IM_MODULE", "gtk-im-context-simple")

------------------------------
---------- Configs -----------
------------------------------
require("conf.colors")
require("conf.start")
require("conf.layout")
require("conf.keybindings")
require("conf.window")
