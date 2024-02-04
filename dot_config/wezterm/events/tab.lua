local wezterm = require("wezterm")

local T = {}

T.bg_color = "none"

function T.on_update_status(window, pane)
	local cwd_uri = pane:get_current_working_dir()
	local right_status = {}
	local left_status = {}

	if cwd_uri then
		local cwd = cwd_uri.file_path
		local hostname = cwd_uri.host or wezterm.hostname()

		-- Remove the domain name portion of the hostname
		local dot = hostname:find("[.]")
		if dot then
			hostname = hostname:sub(1, dot - 1)
		end
		if hostname == "" then
			hostname = wezterm.hostname()
		end

		cwd = cwd:gsub(wezterm.home_dir, "~")

		left_status = {
			{ Foreground = { Color = "rgb(210,55,100)" } },
			{ Background = { Color = T.bg_color } },
			{ Attribute = { Intensity = "Bold" } },
			{ Attribute = { Italic = false } },
			{ Text = "  " },
			{ Text = window:active_workspace() .. " " },
		}

		-- TODO: Show keytable active ("Resize")
		right_status = {
			{ Background = { Color = T.bg_color } },

			{ Foreground = { Color = "rgb(94,172,211)" } },
			{ Attribute = { Italic = true } },
			{ Text = "in " },

			{ Foreground = { Color = "rgb(210,55,100)" } },
			{ Attribute = { Italic = false } },
			{ Text = cwd },

			{ Foreground = { Color = "rgb(94,172,211)" } },
			{ Attribute = { Italic = true } },
			{ Text = " @ " },

			{ Foreground = { Color = "rgb(210,55,100)" } },
			{ Attribute = { Italic = false } },
			{ Text = hostname .. " " },
		}
	end

	window:set_left_status(wezterm.format(left_status))
	window:set_right_status(wezterm.format(right_status))
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

-- TODO: Add better colors to each tab title
---@diagnostic disable-next-line:unused-local
function T.on_format_tab_title(tab, _tabs, _panes, _config, _hover, _max_width)
	local zoomed = ""
	local index = tab.tab_index + 1
	local title = tab_title(tab)
	if tab.active_pane.is_zoomed then
		zoomed = "+"
	end
	return {
		{ Text = string.format(" %d %s%s ", index, title, zoomed) },
	}
end

function T.setup()
	wezterm.on("update-status", T.on_update_status)
	wezterm.on("format-tab-title", T.on_format_tab_title)
end

return T
