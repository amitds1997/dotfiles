local awful = require("awful")

return function(s)
	return awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		button = {
			-- Left-click on client indicator = Toggles it's minimized state.
			awful.button({}, 1, function(c)
				c:activate({ context = "tasklist", action = "toggle_minimization" })
			end),
			-- Right-click on client indicator = Shows all open clients in all visible tags
			awful.button({}, 3, function()
				awful.menu.client_list({ theme = { width = 250 } })
			end),
			-- Scrolls through clients
			awful.button({}, 4, function()
				awful.client.focus.byidx(-1)
			end),
			awful.button({}, 5, function()
				awful.client.focus.byidx(1)
			end),
		},
	})
end
