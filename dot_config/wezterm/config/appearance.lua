-- TODO: Handle day-light change
-- if wezterm.gui.get_appearance():find("Dark") then
-- 	config.color_scheme = "Tokyo Night Moon"
-- else
-- 	config.color_scheme = "Tokyo Night Day"
-- 	config.window_background_opacity = 0.85
-- end
--
return {
	animation_fps = 60,
	webgpu_power_preference = "HighPerformance",
	color_scheme = "Tokyo Night Moon",

	-- Cursor settings
	default_cursor_style = "BlinkingUnderline",
	window_background_opacity = 0.85,
	window_decorations = "RESIZE",
	inactive_pane_hsb = {
		saturation = 0.8,
		brightness = 0.7,
	},

	-- Tab settings
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	-- show_tab_index_in_tab_bar = false,
	switch_to_last_active_tab_when_closing_tab = true,

	-- Window settings
	window_close_confirmation = "NeverPrompt",
}
