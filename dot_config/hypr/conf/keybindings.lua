------------------------------------
------------ Keybindings -----------
------------------------------------

local mainMod = "SUPER"
local cmd = hl.dsp.exec_cmd
local window = hl.dsp.window
local layout = hl.dsp.layout
local var = require("conf.variables")
local m1 = "DP-1"
local m2 = "HDMI-A-1"

-- QoL
hl.bind(
	mainMod .. " + m",
	cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind("PRINT", cmd("slurp | grim -g - - | wl-copy -t image/png"))
hl.bind(mainMod .. " + q", window.close())
hl.bind(mainMod .. " + f", window.fullscreen())
hl.bind(mainMod .. " + ALT + SHIFT + v", window.float({ action = "toggle" }))

-- Dwindle
hl.bind(mainMod .. " + ALT + SHIFT + p", window.pseudo())
hl.bind(mainMod .. " + ALT + SHIFT + p", layout("togglesplit"))

-- Master -> Workspace 1
hl.bind(mainMod .. " + s", layout("swapwithmaster ignoremaster"))
hl.bind(mainMod .. " + a", layout("addmaster"))
hl.bind(mainMod .. " + d", layout("removemaster"))

-- Applications
hl.bind(mainMod .. " + RETURN", cmd(var.terminal))
hl.bind(mainMod .. " + r", cmd(var.menu))
hl.bind(mainMod .. " + v", cmd(var.cliphist))
hl.bind(mainMod .. " + ALT + p", cmd("hyprpicker -an"))
hl.bind(mainMod .. " + ALT + q", cmd("wlogout"))
hl.bind(mainMod .. " + ALT + l", cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + x", cmd(var.sql))
hl.bind(mainMod .. " + SHIFT + p", cmd("bruno"))
hl.bind(mainMod .. " + SHIFT + b", cmd(var.browser))
hl.bind(mainMod .. " + SHIFT + i", cmd(var.gimp))
hl.bind(mainMod .. " + SHIFT + c", cmd(var.calc))
hl.bind(mainMod .. " + SHIFT + x", cmd(var.terminal))
hl.bind(mainMod .. " + SHIFT + d", cmd(var.discord))
hl.bind(mainMod .. " + SHIFT + s", cmd(var.steam))
hl.bind(mainMod .. " + SHIFT + w", cmd("~/.config/waybar/launch.sh"))
hl.bind(
	mainMod .. " + SHIFT + g",
	cmd(
		"google-chrome-stable --ozone-platform=wayland --disable-gpu-driver-bug-workarounds --use-gl=egl --disable-direct-composition"
	)
)

-- Resize window
hl.bind(mainMod .. " + LEFT", window.resize({ x = -5, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + RIGHT", window.resize({ x = 5, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + UP", window.resize({ x = 0, y = 5, relative = true }), { repeating = true })
hl.bind(mainMod .. " + DOWN", window.resize({ x = 0, y = -5, relative = true }), { repeating = true })

-- Move focus (vim)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))

-- Move window (vim)
hl.bind(mainMod .. " + SHIFT + h", window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + j", window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + k", window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + l", window.move({ direction = "r" }))

for i = 1, 10 do
	local key = i % 10

	-- Switch workspaces
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))

	-- Move workspaces
	hl.bind(mainMod .. " + SHIFT + " .. key, window.move({ workspace = i }))
end

-- Switch monitors
hl.bind(mainMod .. " + ALT + 1", hl.dsp.workspace.move({ monitor = m1 }))
hl.bind(mainMod .. " + ALT + 2", hl.dsp.workspace.move({ monitor = m2 }))

-- Mouse
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", window.resize(), { mouse = true })

-- Keyboard
hl.bind(mainMod .. " + XF86AudioMute", cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMute", cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioStop", cmd("playerctl stop"), { locked = true })
hl.bind("XF86AudioPlay", cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", cmd("playerctl next"), { locked = true })
hl.bind(
	"XF86AudioRaiseVolume",
	cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	mainMod .. " + XF86AudioRaiseVolume",
	cmd("wpctl set-volume -l 2 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioLowerVolume", cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
