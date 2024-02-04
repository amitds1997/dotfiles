local wezterm = require("wezterm")

--- Spawn in full screen
wezterm.on("gui-startup", function()
	local _, _, window = wezterm.mux.spawn_window({})
	window:gui_window():maximize()
end)
