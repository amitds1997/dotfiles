local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

local menu = {}
local apps = require("core.apps")

menu.awesome = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", apps.terminal .. " -e man awesome" },
	{ "edit config", apps.editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

menu.main = awful.menu({
	items = {
		{ "awesome", menu.awesome, beautiful.awesome_icon },
		{ "open terminal", apps.terminal },
	},
})

return menu
