local wezterm = require("wezterm")
local machine = require("utils.machine")

local fantasque_sans_mono_font = (machine.platform.is_mac and "FantasqueSansMono Nerd Font Mono")
	or "FantasqueSansM Nerd Font Mono"
local font_size = machine.platform.is_mac and 17 or 12

return {
	font = wezterm.font_with_fallback({
		"Rec Mono Duotone",
		"codicon",
		"nonicons",
		"Symbols Nerd Font Mono",
		fantasque_sans_mono_font,
		"Noto Color Emoji",
	}),
	font_size = font_size,
	adjust_window_size_when_changing_font_size = true,
}
