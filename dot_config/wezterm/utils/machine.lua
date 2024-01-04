local wezterm = require("wezterm")

return {
	platform = {
		is_windows = wezterm.target_triple:find("windows"),
		is_linux = wezterm.target_triple:find("linux"),
		is_mac = wezterm.target_triple:find("darwin"),
	},
	arch = {
		is_x86 = wezterm.target_triple:find("x86_64"),
		is_arch = wezterm.target_triple:find("arch"),
	},
}
