local wezterm = require("wezterm")
local machine = require("utils.machine")
local workspace = require("utils.workspace")
local act = wezterm.action

local mod = {}

if machine.platform.is_mac then
	mod.SUPER = "CTRL"
	mod.SUPER_REV = "CTRL|SHIFT"
else
	mod.SUPER = "ALT"
	mod.SUPER_REV = "ALT|SHIFT"
end

local key_tables = {
	resize_pane = {
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},
}

local keys = {
	--- Misc
	{ key = "v", mods = mod.SUPER_REV, action = act.ActivateCopyMode },
	{ key = "p", mods = mod.SUPER_REV, action = act.ActivateCommandPalette },
	{ key = "l", mods = mod.SUPER_REV, action = act.ShowLauncher },
	{ key = "t", mods = mod.SUPER_REV, action = act.ShowTabNavigator },
	{ key = "F12", mods = "NONE", action = act.ShowDebugOverlay },

	--- Copy/Paste
	{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
	{ key = "c", mods = mod.SUPER_REV, action = act.CopyTo("Clipboard") },
	{ key = "v", mods = mod.SUPER_REV, action = act.PasteFrom("Clipboard") },

	--- Search
	{ key = "f", mods = "SUPER", action = act.Search({ CaseInSensitiveString = "" }) },
	{ key = "f", mods = mod.SUPER_REV, action = act.Search({ CaseInSensitiveString = "" }) },

	--- Toggle fullscreen
	{ key = "Enter", mods = mod.SUPER_REV, action = act.ToggleFullScreen },

	--- Tabs: Open/Close
	{ key = "t", mods = "SUPER", action = act.SpawnTab("DefaultDomain") },
	{ key = "w", mods = "SUPER", action = act.CloseCurrentTab({ confirm = false }) },

	--- Tabs: Navigation
	{ key = "[", mods = mod.SUPER_REV, action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = mod.SUPER_REV, action = act.ActivateTabRelative(1) },
	{ key = "Tab", mods = mod.SUPER, action = act.ActivateTabRelative(1) },
	{ key = "Tab", mods = mod.SUPER_REV, action = act.ActivateTabRelative(1) },

	-- Spawn new windows
	{ key = "n", mods = "SUPER", action = act.SpawnWindow },
	{ key = "n", mods = mod.SUPER_REV, action = act.SpawnWindow },

	-- Panes: Split
	{
		key = [[\]],
		mods = mod.SUPER_REV,
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = [[\]],
		mods = mod.SUPER,
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	-- Panes: Zoom+Close
	{ key = "z", mods = mod.SUPER_REV, action = act.TogglePaneZoomState },
	{ key = "w", mods = mod.SUPER_REV, action = act.CloseCurrentPane({ confirm = true }) },

	-- Panes: Navigation
	{ key = "k", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Down") },
	{ key = "h", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Right") },
	{
		key = ",",
		mods = mod.SUPER_REV,
		action = act.PaneSelect({
			alphabet = "1234567890",
		}),
	},
	{
		key = ".",
		mods = mod.SUPER_REV,
		action = act.PaneSelect({
			alphabet = "1234567890",
			mode = "SwapWithActiveKeepFocus",
		}),
	},

	-- Resize panes
	{
		key = "r",
		mods = mod.SUPER_REV,
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
			timemout_miliseconds = 1000,
		}),
	},

	-- Adjust font size
	{ key = "-", mods = "SUPER", action = act.DecreaseFontSize },
	{ key = "=", mods = "SUPER", action = act.IncreaseFontSize },
	{ key = "0", mods = "SUPER", action = wezterm.action.ResetFontSize },

	-- Workspaces
	{ key = "s", mods = mod.SUPER_REV, action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "n",
		mods = mod.SUPER_REV,
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(workspace.create_workspace),
		}),
	},
}

for i = 1, 9 do
	table.insert(keys, {
		key = tostring(i),
		mods = mod.SUPER,
		action = act.ActivateTab(i - 1),
	})
end

return {
	leader = { key = "Space", mods = mod.SUPER_REV },
	disable_default_key_bindings = true,
	keys = keys,
	key_tables = key_tables,
}
