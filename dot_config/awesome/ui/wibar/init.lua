local awful = require("awful")
local wibox = require("wibox")
local components = require("ui.wibar.components")

return function(s)
	-- Create a promptbox
	s.mypromptbox = awful.widget.prompt()

	-- Create a wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		widget = {
			layout = wibox.layout.align.horizontal,
			-- Left widgets
			{
				layout = wibox.layout.fixed.horizontal,
				components.launcher(),
				components.taglist(s),
				s.mypromptbox,
			},
			-- Middle widgets
			components.tasklist(s),
			-- Right widgets
			{
				layout = wibox.layout.fixed.horizontal,
				awful.widget.keyboardlayout(),
				wibox.widget.systray(),
				wibox.widget.textclock(),
				components.layoutbox(s),
			},
		},
	})
end
