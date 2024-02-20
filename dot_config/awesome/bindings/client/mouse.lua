local awful = require("awful")
local modkey = require("core.mods").modkey

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		-- Activate clicked client
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		-- Mod + Left-click = Move window
		awful.button({ modkey }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		-- Mod + Right-click = Resize window
		awful.button({ modkey }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)
