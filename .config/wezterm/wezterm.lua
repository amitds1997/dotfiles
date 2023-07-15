local wezterm = require('wezterm')

local config = {
  audible_bell = "Disabled",
  default_cursor_style = "BlinkingUnderline",
  hide_tab_bar_if_only_one_tab = true,
  window_background_opacity = 0.85,
  color_scheme = 'Catppuccin Mocha (Gogh)',
  font = wezterm.font_with_fallback {
    { family = "Rec Mono Duotone",                 weight = "Regular" },
    { family = "FantasqueSansMono Nerd Font Mono", weight = "Regular", stretch = "Normal", style = "Normal" },
    'Noto Color Emoji',
  },
  font_size = 16,
  native_macos_fullscreen_mode = true,
  use_fancy_tab_bar = false,
  check_for_updates = false,
}

local appearance = wezterm.gui.get_appearance()

if appearance:find("Dark") then
  config.color_scheme = 'Catppuccin Mocha (Gogh)'
else
  config.color_scheme = 'Catppuccin Latte (Gogh)'
  config.window_background_opacity = 1
end

return config
