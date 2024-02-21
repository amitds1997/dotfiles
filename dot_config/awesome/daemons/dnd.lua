local naughty = require("naughty")
local beautiful = require("beautiful")

local DnD = {}

DnD.state = false

function DnD:toggle()
	self.state = not self.state
	if self.state then
		naughty.notification({
			title = "Notifications",
			text = "Do not Disturb is on",
			icon = beautiful.icon_bell_off,
		})
		naughty.suspend()
	else
		naughty.notification({
			title = "Notifications",
			text = "Do not Disturb is off",
		})
		naughty.resume()
	end
end

return DnD
