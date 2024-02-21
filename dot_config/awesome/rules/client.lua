local awful = require("awful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()
	-- All clients will follow this rule
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})

	-- Launch following as floating clients
	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			instance = { "pinentry" },
			class = {
				"Tor Browser",
			},
			role = {
				"ConfigManager", -- Thunderbird's about:config
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools
			},
		},
	})

	-- Add titlebars to normal clients and dialogs
	ruled.client.append_rule({
		id = "titlebars",
		rule_any = { type = { "dialog" } },
		properties = { titlebars_enabled = true },
	})
end)
