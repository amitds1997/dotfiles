local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local widgets = require("ui")
local wallpaper_dir = require("core.user").wallpaper_dir

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag(require("core.user").tags, s, awful.layout.layouts[1])
	widgets.wibar(s)
end)

screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper({
		screen = s,
		widget = {
			{
				image = wallpaper_dir .. "/" .. gears.filesystem.get_random_file_from_dir(wallpaper_dir),
				upscale = true,
				downscale = true,
				widget = wibox.widget.imagebox,
			},
			tiled = false,
			halign = "center",
			valign = "center",
			widget = wibox.container.tile,
		},
	})
end)
