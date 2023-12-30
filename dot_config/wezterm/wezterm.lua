local wezterm = require("wezterm")
local hyperlink_rules = require("hyperlink_rules")

local key_mappings = require("keymappings")
local keys, key_tables = key_mappings.keys, key_mappings.key_tables

-- Launch Wezterm in full screen
wezterm.on("gui-startup", function()
	local _, _, window = wezterm.mux.spawn_window({})
	window:gui_window():maximize()
end)

local fantasque_sans_mono_font = (require("utils.platform").platform.is_mac and "FantasqueSansMono Nerd Font Mono")
	or "FantasqueSansM Nerd Font Mono"

local config = {
	-- General config
	audible_bell = "Disabled",
	check_for_updates = false,
	hyperlink_rules = hyperlink_rules,
	native_macos_fullscreen_mode = true,
	scrollback_lines = 5000,
	use_ime = false,

	-- Keyboard mappings setup
	key_tables = key_tables,
	keys = keys,

	-- Appearance configuration
	default_cursor_style = "BlinkingUnderline",
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	window_background_opacity = 0.85,
	window_decorations = "RESIZE",
	inactive_pane_hsb = {
		saturation = 0.8,
		brightness = 0.7,
	},

	-- Font configuration
	font_size = 17,
	font = wezterm.font_with_fallback({
		{ family = "Rec Mono Duotone", weight = "Regular" },
		"codicon",
		"nonicons",
		{ family = fantasque_sans_mono_font, weight = "Regular", stretch = "Normal", style = "Normal" },
		"Noto Color Emoji",
		"Symbols Nerd Font Mono",
	}),
}

if wezterm.gui.get_appearance():find("Dark") then
	config.color_scheme = "Tokyo Night Moon"
else
	config.color_scheme = "Tokyo Night Day"
	config.window_background_opacity = 0.85
end

return config
