local awful = require("awful")
local beautiful = require("beautiful")

return function()
	return awful.widget.launcher({
		image = beautiful.awesome_icon,
		menu = require("ui.menu").main,
	})
end
