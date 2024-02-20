-- Theme handling library
local beautiful = require("beautiful")
-- Standard awesome library
local gears = require("gears")

-- Themes define colors, icons, font and wallpapers.
-- beautiful.init(awful.util.get_configuration_dir() .. "themes/default/theme.lua")
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
