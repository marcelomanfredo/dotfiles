----------------------------
--------- Layouts ----------
----------------------------

hl.config({
	general = {
		layout = "dwindle",
		gaps_in = 2,
		gaps_out = 3,
		border_size = 2,
		resize_on_border = false,
		allow_tearing = false,

		col = {
			active_border = {
				colors = {
					"rgba(1c3f7ce6)",
					"rgba(7eb1ffe6)",
				},
				angle = 270,
			},
			inactive_border = "rgba(0c0c0cb3)",
		},
	},

	decoration = {
		rounding = 13,
		active_opacity = 0.95,
		inactive_opacity = 0.95,
		fullscreen_opacity = 0.95,
		dim_inactive = true,
		dim_strength = 0.4525,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 2,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 4,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	input = {
		kb_layout = "br",
		kb_variant = "abnt2",
		kb_options = "ctrl:nocaps, caps:none",
		numlock_by_default = true,

		follow_mouse = 2,
		sensitivity = 0,
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		mfact = 0.6,
		new_status = "slave",
	},

	misc = {
		disable_hyprland_logo = true,
		col = {
			splash = "rgba(1c3f7ce6)",
		},
		font_family = "FiraMonoNerdFont",
		splash_font_family = "FiraMonoNerdFont",
		force_default_wallpaper = 0,
		focus_on_activate = false,
		mouse_move_focuses_monitor = false,
	},

	cursor = {
		no_warps = true,
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
})
