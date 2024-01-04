local wezterm = require("wezterm")
local GLYPH_LEFT_SEPARATOR = ""
local GLYPH_RIGHT_SEPARATOR = ""
local GLYPH_CIRCLE = wezterm.nerdfonts.oct_dot_fill

local M = {}

M.colors = {
	default = {
		bg = "#45475a",
		fg = "#1c1b19",
	},
	is_active = {
		bg = "#7FB4CA",
		fg = "#11111b",
	},

	hover = {
		bg = "#587d8c",
		fg = "#1c1b19",
	},
}

M.icons = {
	nvim = wezterm.nerdfonts.custom_vim,
	vim = wezterm.nerdfonts.custom_vim,
	zsh = wezterm.nerdfonts.dev_terminal_badge,
	bash = wezterm.nerdfonts.dev_terminal_badge,
	sh = wezterm.nerdfonts.dev_terminal_badge,
}

M.get_process_name = function(tab)
	local a = tab.active_pane.foreground_process_name:gsub("(.*[/\\])(.*)", "%2")
	return a:gsub("%.exe$", "")
end

M.set_title = function(process_name, base_title, max_width, inset)
	local title
	inset = inset or 2

	if process_name:len() > 0 then
		title = process_name
	else
		title = base_title
	end

	local icon = M.icons[title]
	if icon ~= nil then
		title = icon .. " " .. title
	end

	if title:len() > max_width - inset then
		local diff = title:len() - max_width + inset
		title = wezterm.truncate_right(title, title:len() - diff)
	end

	return title
end

---@param fg string
---@param bg string
---@param attribute table
---@param text string
M.push = function(bg, fg, attribute, text)
	if bg then
		table.insert(M.cells, { Background = { Color = bg } })
	end
	if fg then
		table.insert(M.cells, { Foreground = { Color = fg } })
	end
	if attribute then
		table.insert(M.cells, { Attribute = attribute })
	end
	table.insert(M.cells, { Text = text })
end

M.setup = function()
	wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
		local process_name = M.get_process_name(tab)
		local title = M.set_title(process_name, tab.active_pane.title, max_width)
		M.cells = {}

		local bg
		local fg

		if tab.is_active then
			bg = M.colors.is_active.bg
			fg = M.colors.is_active.fg
		elseif hover then
			bg = M.colors.hover.bg
			fg = M.colors.hover.fg
		else
			bg = M.colors.default.bg
			fg = M.colors.default.fg
		end

		local has_unseen_output = false
		for _, pane in ipairs(tab.panes) do
			if pane.has_unseen_output then
				has_unseen_output = true
				break
			end
		end

		-- Title
		M.push(bg, fg, { Intensity = "Bold" }, " " .. GLYPH_LEFT_SEPARATOR)
		M.push(bg, fg, { Intensity = "Bold" }, " " .. title)

		if has_unseen_output then
			M.push(bg, "#FFA066", { Intensity = "Bold" }, " " .. GLYPH_CIRCLE)
		end
		M.push(bg, fg, { Intensity = "Bold" }, " ")
		M.push(bg, fg, { Intensity = "Bold" }, " " .. GLYPH_RIGHT_SEPARATOR)

		return M.cells
	end)
end

return M
