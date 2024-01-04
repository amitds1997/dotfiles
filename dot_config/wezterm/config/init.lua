local wezterm = require("wezterm")

---@class WeztermConfig
---@field options table
local WeztermConfig = {}

function WeztermConfig:init()
	local o = {}
	self = setmetatable(o, { __index = WeztermConfig })
	self.options = {}
	return o
end

---Append to existing configuration options
---@param new_opts table New options to be added
---@return WeztermConfig
function WeztermConfig:append(new_opts)
	for k, v in pairs(new_opts) do
		if self.options[k] ~= nil then
			wezterm.log_warn("Duplicate config option found: ", { old = self.options[k], new = new_opts[k] })
		else
			self.options[k] = v
		end
	end
	return self
end

return WeztermConfig
