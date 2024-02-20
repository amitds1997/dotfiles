local awful = require("awful")
local wibox = require("wibox")

return function(c)
	local buttons = {
		awful.button({}, 1, function()
			c:activate({ context = "titlebar", action = "mouse_move" })
		end),
		awful.button({}, 3, function()
			c:activate({ context = "titlebar", action = "mouse_resize" })
		end),
	}

	-- Draw the client titlebar at the default position (top)
	awful.titlebar(c).widget = wibox.widget({
		layout = wibox.layout.align.horizontal,
		-- Left
		{
			layout = wibox.layout.fixed.horizontal,
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
		},
		-- Middle
		{
			layout = wibox.layout.flex.horizontal,
			{ -- Title
				widget = awful.titlebar.widget.titlewidget(c),
				halign = "center",
			},
			buttons = buttons,
		},
		-- Right
		{
			layout = wibox.layout.fixed.horizontal,
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
		},
	})
end
