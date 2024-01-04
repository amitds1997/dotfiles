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
		fantasque_sans_mono_font,
		"Noto Color Emoji",
		"Symbols Nerd Font Mono",
	}),
	font_size = font_size,
}
