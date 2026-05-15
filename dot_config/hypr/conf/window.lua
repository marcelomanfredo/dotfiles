local m1 = "DP-1"
local m2 = "HDMI-A-1"

-- Windows
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { class = ".*ghostty" }, workspace = "1" })
hl.window_rule({ match = { class = "firefox" }, workspace = "2" })
hl.window_rule({ match = { class = "steam.*" }, workspace = "3", tile = true })
hl.window_rule({ match = { class = "google-chrome" }, workspace = "4" })
hl.window_rule({ match = { class = "bruno" }, workspace = "5" })
hl.window_rule({ match = { class = "DBeaver" }, workspace = "6" })
hl.window_rule({ match = { class = "gimp" }, workspace = "7" })
hl.window_rule({ match = { class = "discord" }, workspace = "9" })
hl.window_rule({ match = { class = "firefox|discord|steam|gimp" }, opaque = true })
hl.window_rule({ match = { fullscreen = true, class = "negative:.*ghostty" }, opaque = true })
hl.window_rule({ match = { class = "(^qalc.*)" }, float = true })

-- Workspaces
hl.workspace_rule({ workspace = "1", monitor = m1, persistent = true, default = true, layout = "master" })
hl.workspace_rule({
	workspace = "2",
	monitor = m2,
	persistent = true,
	default = true,
	gaps_in = 0,
	gaps_out = 1,
	no_rounding = true,
})
hl.workspace_rule({ workspace = "3", monitor = m1, decorate = false })
hl.workspace_rule({ workspace = "4", monitor = m2, decorate = false })
hl.workspace_rule({ workspace = "5", monitor = m2, decorate = false })
hl.workspace_rule({ workspace = "6", monitor = m2, decorate = false })
hl.workspace_rule({ workspace = "7", monitor = m2, decorate = false })
hl.workspace_rule({ workspace = "9", monitor = m2, gaps_in = 0, gaps_out = 1, no_rounding = true })
