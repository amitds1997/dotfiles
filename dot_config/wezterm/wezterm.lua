local Config = require("config")

require("events.startup")
require("events.tab").setup()

return Config:init()
	:append(require("config.general"))
	:append(require("config.appearance"))
	:append(require("config.bindings"))
	:append(require("config.fonts"))
	:append(require("config.tab"))
	:append(require("config.hyperlinks")).options
