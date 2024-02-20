client.connect_signal("request::titlebars", function(c)
	if c.request_no_titlebars then
		return
	end

	require("ui.titlebar").default(c)
end)

client.connect_signal("mouse::enter", function(c)
	c:activate({ context = "mouse_enter", raise = false })
end)
