-- TODO: Handle light-dark system colorscheme
return {
	max_fps = 120,
	animation_fps = 60,
	webgpu_power_preference = "HighPerformance",
	---@type "tokyonight_night"|"Catppuccin Mocha"|"Rosé Pine Moon (Gogh)"
	color_scheme = "tokyonight_night",
	freetype_load_flags = "NO_HINTING",

	-- Cursor settings
	default_cursor_style = "BlinkingUnderline",
	window_background_opacity = 0.80,
	window_decorations = "RESIZE",
	inactive_pane_hsb = {
		saturation = 0.5,
		brightness = 0.4,
	},

	-- Window settings
	window_close_confirmation = "NeverPrompt",
}
