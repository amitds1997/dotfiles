local awful = require("awful")

return {
	wallpaper_dir = awful.util.get_configuration_dir() .. "/wallpapers",
	-- Each screen has its own tag table. You can just define one and append it to all
	-- screens (default behavior).
	tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
	-- Table of layouts to cover with awful.layout.inc, ORDER MATTERS, the first layout
	-- in the table is your DEFAULT LAYOUT.
	layouts = {
		awful.layout.suit.tile,
		awful.layout.suit.floating,
		awful.layout.suit.tile.left,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.tile.top,
		awful.layout.suit.fair,
		awful.layout.suit.fair.horizontal,
		awful.layout.suit.spiral,
		awful.layout.suit.spiral.dwindle,
		awful.layout.suit.max,
		awful.layout.suit.max.fullscreen,
		awful.layout.suit.magnifier,
		awful.layout.suit.corner.nw,
	},
}
