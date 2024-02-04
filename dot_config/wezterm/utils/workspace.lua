local wezterm = require("wezterm")
local act = wezterm.action
local W = {}

function W.create_workspace(window, pane, line)
	-- line will be `nil` if they hit escape without entering anything
	-- An empty string if they just hit enter
	-- Or the actual line of text they wrote
	if line then
		window:perform_action(
			act.SwitchToWorkspace({
				name = line,
			}),
			pane
		)
	end
end

return W
