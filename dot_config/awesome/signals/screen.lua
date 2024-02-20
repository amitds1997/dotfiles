local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local widgets = require("ui")

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag(require("core.user").tags, s, awful.layout.layouts[1])
	widgets.wibar(s)
end)

screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper({
		screen = s,
		widget = {
			{
				image = beautiful.wallpaper,
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
