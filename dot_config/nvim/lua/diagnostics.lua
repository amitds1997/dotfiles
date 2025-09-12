-- We only show the diagnostic messages only on the current line but show signs in the statusline for all diagnostics.
-- So, we have to set virtual_text to false to set our own extmarks.
local diagnostic_icons = require("core.constants").diagnostics_icons
local keymap = require("core.utils").set_keymap
local special_sources = {
  ["Lua Diagnostics."] = "lua",
  ["Lua Syntax Check."] = "lua",
}

local severity_cache = {}

---@param severity vim.diagnostic.Severity
local function get_level_and_hl(severity)
  if severity_cache[severity] then
    return unpack(severity_cache[severity])
  end

  local level = vim.diagnostic.severity[severity]
  local hl_group = "Diagnostic" .. level:gsub("^%l", string.upper)

  severity_cache[severity] = { level, hl_group }
  return level, hl_group
end

local function get_icon(level)
  return diagnostic_icons[level] or ""
end

local function get_source(source)
  return source and special_sources[source] or source
end

local function format_code(code)
  return code and string.format(" [%s] ", code) or ""
end

vim.diagnostic.config {
  severity_sort = true,
  signs = false,
  float = {
    severity_sort = true,
    prefix = function(diagnostic)
      local level, hl_group = get_level_and_hl(diagnostic.severity)
      local source = get_source(diagnostic.source)
      local icon = get_icon(level):gsub("%s+$", "")

      if source then
        return string.format(" %s %s: ", icon, source), hl_group
      end

      return string.format(" %s", icon), hl_group
    end,
    format = function(diagnostic)
      return diagnostic.message
    end,
    suffix = function(diagnostic)
      local _, hl_group = get_level_and_hl(diagnostic.severity)
      return format_code(diagnostic.code), hl_group
    end,
  },
  virtual_text = {
    prefix = function(diagnostic)
      local level, _ = get_level_and_hl(diagnostic.severity)
      return " " .. get_icon(level)
    end,
    spacing = 2,
    current_line = true,
    format = function(diagnostic)
      local message = diagnostic.message
      local source = get_source(diagnostic.source)

      if diagnostic.source then
        message = string.format("%s: %s", source, message)
      end

      return message .. " "
    end,
    suffix = function(diagnostic)
      return format_code(diagnostic.code)
    end,
  },
}

keymap("<leader>Dc", function()
  vim.diagnostic.open_float {
    scope = "cursor",
  }
end, "Cursor position diagnostics")
keymap("<leader>Dl", function()
  vim.diagnostic.open_float {
    scope = "line",
  }
end, "Line diagnostics")
keymap("<leader>Db", function()
  vim.diagnostic.setloclist()
end, "Buffer diagnostics")
keymap("<leader>Dw", function()
  vim.diagnostic.setqflist()
end, "Workspace diagnostics")

vim.api.nvim_create_autocmd("FileType", {
  pattern = require("settings").meta_filetypes,
  desc = "Disable diagnostics for meta-filetypes",
  callback = function(ev)
    vim.diagnostic.enable(false, {
      bufnr = ev.buf,
    })
  end,
})
