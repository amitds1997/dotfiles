-- local wezterm = require("wezterm")
local Config = require("config")

require("events.tab-title").setup()

return Config:init()
	:append(require("config.general"))
	:append(require("config.appearance"))
	:append(require("config.bindings"))
	:append(require("config.fonts"))
	:append(require("config.hyperlinks")).options
