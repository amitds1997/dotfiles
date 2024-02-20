tag.connect_signal("request::default_layouts", function()
	require("awful").layout.append_default_layouts(require("core.user").layouts)
end)
