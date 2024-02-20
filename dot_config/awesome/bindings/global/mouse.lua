local awful = require("awful")
local awesome_menu = require("ui.menu").main

awful.mouse.append_global_mousebindings({
	-- Right click globally opens AwesomeWM menu
	awful.button({}, 3, function()
		awesome_menu:toggle()
	end),
	-- Mouse scroll switches through tags
	awful.button({}, 4, awful.tag.viewprev),
	awful.button({}, 5, awful.tag.viewnext),
})
