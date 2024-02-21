-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Error handling
local naughty = require("naughty")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

-- Allow Awesome to automatically focus a client upon changing tags or loading
require("awful.autofocus")

-- Load chosen theme
require("themes")

-- Load all signals
require("signals")

-- Load all keyboard+mouse bindings
require("bindings")

-- Load all rules
require("rules")

-- Launch autostart apps
require("core.autostart")
