local awful = require("awful")
local mods = require("core.mods")
local modkey = mods.modkey

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		-- Client state management
		awful.key({ modkey }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "Toggle fullscreen", group = "client" }),
		awful.key({ modkey, mods.shift }, "c", function(c)
			c:kill()
		end, { description = "Close client", group = "client" }),
		awful.key(
			{ modkey, mods.ctrl },
			"space",
			awful.client.floating.toggle,
			{ description = "Toggle floating for client", group = "client" }
		),
		awful.key({ modkey }, "n", function(c)
			-- The client currently has input focus, so it cannot be minimized,
			-- since minimized clients cannot have the focus.
			c.minimized = true
		end, { description = "Minimize client", group = "client" }),
		awful.key({ modkey }, "m", function(c)
			c.maximized = not c.maximized
			c:raise()
		end, { description = "(Un)Maximize the client", group = "client" }),
		awful.key({ modkey, mods.ctrl }, "m", function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end, { description = "(Un)Maximize the client veritically", group = "client" }),
		awful.key({ modkey, mods.shift }, "m", function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end, { description = "(Un)Maximize the client horizontally", group = "client" }),

		-- Client position in the tiling manager
		awful.key({ modkey, mods.ctrl }, "Return", function(c)
			c:swap(awful.client.getmaster())
		end, { description = "Move to master", group = "client" }),
		awful.key({ modkey }, "o", function(c)
			c:move_to_screen()
		end, { description = "Move to screen", group = "client" }),
		awful.key({ modkey }, "t", function(c)
			c.ontop = not c.ontop
		end, { description = "Toggle keep on top", group = "client" }),
	})
end)
