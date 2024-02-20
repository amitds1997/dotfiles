local naughty = require("naughty")

-- Defines the default notification layout.
naughty.connect_signal("request::display", function(n)
	naughty.layout.box({ notification = n })
end)
