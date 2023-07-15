local wezterm = require('wezterm')
local hyperlink_rules = require('hyperlink_rules')

local config = {
  -- General config
  audible_bell = "Disabled",
  check_for_updates = false,
  hyperlink_rules = hyperlink_rules,
  native_macos_fullscreen_mode = true,

  -- Appearance configuration
  color_scheme = 'Catppuccin Mocha (Gogh)',
  default_cursor_style = "BlinkingUnderline",
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  window_background_opacity = 0.85,

  -- Font configuration
  font_size = 16,
  font = wezterm.font_with_fallback {
    { family = "Rec Mono Duotone",                 weight = "Regular" },
    { family = "FantasqueSansMono Nerd Font Mono", weight = "Regular", stretch = "Normal", style = "Normal" },
    'Noto Color Emoji',
  },
}

local appearance = wezterm.gui.get_appearance()

if appearance:find("Dark") then
  config.color_scheme = 'Catppuccin Mocha (Gogh)'
else
  config.color_scheme = 'Catppuccin Latte (Gogh)'
  config.window_background_opacity = 1
end

return config
