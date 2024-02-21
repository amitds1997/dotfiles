local awful = require("awful")
local WiFi = {}

WiFi.hw = nil
WiFi.status = false

function WiFi:get_status()
	awful.spawn.easy_async_with_shell("iwctl device list | sed 1,4d | awk '{print $2, $4}'", function(stdout)
		local hw, status = stdout:match("(%w+)%s+(%w+)")
		if hw ~= "" and status == "on" then
			self.hw = hw
			self.status = true
			self:scan()
		else
			self.status = false
		end
		awesome.emit_signal("wifi:status", self.status)
	end)
end

function WiFi:toggle()
	-- if self.status then
	-- 	awful.spawn.easy_async_with_shell(("iwctl device %s set-property Powered off"):format(self.hw), function()
	-- 		self:get_status()
	-- 	end)
	-- elseif self.hw ~= nil then
	-- 	awful.spawn.easy_async_with_shell(("iwctl device %s set-property Powered on"):format(self.hw), function()
	-- 		self:get_status()
	-- 	end)
	-- end
end

function WiFi:scan()
	-- awesome.emit_signal("wifi:scan_started")
	-- local wifi_list = {}
end

function WiFi:connect() end

---@private
function WiFi:_send_notification() end

return WiFi
