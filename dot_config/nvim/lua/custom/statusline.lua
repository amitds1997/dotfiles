local M = {}
local _colorscheme_cache = {}
local gather_hl = require("utils.color").gather_hl_info

local function inverted_hl(hl, force)
  force = force or false
  if (_colorscheme_cache[hl] == nil) or force then
    local inverted_name = ("Inverted%s"):format(hl)
    local hl_def = gather_hl(hl)
    hl_def.fg, hl_def.bg = hl_def.bg, hl_def.fg
    vim.api.nvim_set_hl(0, inverted_name, hl_def)
    _colorscheme_cache[hl] = inverted_name
  end
  return _colorscheme_cache[hl]
end

--- Force-recreate inverted highlights for all cached highlights when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    for _, hl in ipairs(vim.tbl_keys(_colorscheme_cache)) do
      inverted_hl(hl, true)
    end
  end,
})

local mode_info = {
  n = { name = "NORMAL", hl = "MiniStatuslineModeNormal" },
  no = { name = "NORMAL", hl = "MiniStatuslineModeNormal" },
  nov = { name = "NORMAL", hl = "MiniStatuslineModeNormal" },
  noV = { name = "NORMAL", hl = "MiniStatuslineModeNormal" },
  ["no\022"] = { name = "NORMAL", hl = "MiniStatuslineModeNormal" },
  niI = { name = "NORMAL", hl = "MiniStatuslineModeNormal" },
  niR = { name = "NORMAL", hl = "MiniStatuslineModeNormal" },
  niV = { name = "NORMAL", hl = "MiniStatuslineModeNormal" },
  nt = { name = "NORMAL", hl = "MiniStatuslineModeNormal" },
  ntT = { name = "NORMAL", hl = "MiniStatuslineModeNormal" },

  v = { name = "VISUAL", hl = "MiniStatuslineModeVisual" },
  vs = { name = "VISUAL", hl = "MiniStatuslineModeVisual" },
  V = { name = "VISUAL", hl = "MiniStatuslineModeVisual" },
  Vs = { name = "VISUAL", hl = "MiniStatuslineModeVisual" },
  ["\022"] = { name = "VISUAL", hl = "MiniStatuslineModeVisual" },
  ["\022s"] = { name = "VISUAL", hl = "MiniStatuslineModeVisual" },

  s = { name = "SELECT", hl = "MiniStatuslineModeVisual" },
  S = { name = "SELECT", hl = "MiniStatuslineModeVisual" },
  ["\019"] = { name = "SELECT", hl = "MiniStatuslineModeVisual" },

  i = { name = "INSERT", hl = "MiniStatuslineModeInsert" },
  ic = { name = "INSERT", hl = "MiniStatuslineModeInsert" },
  ix = { name = "INSERT", hl = "MiniStatuslineModeInsert" },

  R = { name = "REPLACE", hl = "MiniStatuslineModeReplace" },
  Rc = { name = "REPLACE", hl = "MiniStatuslineModeReplace" },
  Rx = { name = "REPLACE", hl = "MiniStatuslineModeReplace" },
  Rv = { name = "REPLACE", hl = "MiniStatuslineModeReplace" },
  Rvc = { name = "REPLACE", hl = "MiniStatuslineModeReplace" },
  Rvx = { name = "REPLACE", hl = "MiniStatuslineModeReplace" },

  c = { name = "COMMAND", hl = "MiniStatuslineModeCommand" },
  cr = { name = "COMMAND", hl = "MiniStatuslineModeCommand" },
  cv = { name = "COMMAND", hl = "MiniStatuslineModeCommand" },
  cvr = { name = "COMMAND", hl = "MiniStatuslineModeCommand" },

  r = { name = "PROMPT", hl = "MiniStatuslineModeOther" },
  rm = { name = "PROMPT", hl = "MiniStatuslineModeOther" },
  ["r?"] = { name = "PROMPT", hl = "MiniStatuslineModeOther" },
  ["!"] = { name = "SHELL", hl = "MiniStatuslineModeOther" },
  t = { name = "TERMINAL", hl = "MiniStatuslineModeOther" },
}

local function apply_hl(val, hl_group)
  return "%#" .. hl_group .. "#" .. val .. "%#Normal#"
end

local function ah(val, hl_group)
  if val ~= "" then
    val = " " .. val .. " "
  end
  return apply_hl(val, hl_group)
end

local function get_mode_info()
  local mode = vim.api.nvim_get_mode().mode
  local info = mode_info[mode] or { name = mode, hl = "MiniStatuslineModeOther" }
  return { info.name, info.hl, inverted_hl(info.hl) }
end

function M.filename_component()
  if vim.bo.buftype == "terminal" then
    return "%t"
  end

  local filename = vim.api.nvim_buf_get_name(0)
  if filename == "" then
    filename = "No Name"
  else
    filename = vim.fs.basename(filename)
  end

  local status = { filename }

  if vim.bo.modified then
    table.insert(status, "%#DiagnosticError#")
  end
  if vim.bo.readonly then
    table.insert(status, "%#DiagnosticWarn#")
  end

  return table.concat(status, " ")
end

function M.git_branch()
  local summary = vim.b[0].minigit_summary

  if summary == nil or summary.head_name == nil then
    return ""
  end

  return " " .. summary.head_name
end

local last_diagnostic_component = ""
--- Show diagnotics in the statusline
function M.diagnostics_component()
  if vim.startswith(vim.api.nvim_get_mode().mode, "i") then
    return last_diagnostic_component
  end

  local counts = vim.iter(vim.diagnostic.get(0)):fold({
    ERROR = 0,
    WARN = 0,
    HINT = 0,
    INFO = 0,
  }, function(acc, diagnotic)
    local severity = vim.diagnostic.severity[diagnotic.severity]
    acc[severity] = acc[severity] + 1
    return acc
  end)

  local parts = vim
    .iter(counts)
    :map(function(severity, count)
      if count == 0 then
        return nil
      end

      local hl = "Diagnostic" .. severity:sub(1, 1) .. severity:sub(2):lower()
      return string.format("%%#%s#%s:%d", hl, severity:sub(1, 1):upper(), count)
    end)
    :totable()
  return table.concat(parts, " ") .. "%#Normal#"
end

function M.filetype_component()
  local dev_icons = require "nvim-web-devicons"
  local filetype = vim.bo.filetype
  if filetype == "" then
    filetype = "[No Name]"
  end

  local buf_name = vim.api.nvim_buf_get_name(0)
  local name = vim.fs.basename(buf_name)
  local ext = name:match "^.+%.(.+)$" or ""

  local icon, icon_hl = dev_icons.get_icon(name, ext)

  if not icon then
    icon, icon_hl = dev_icons.get_icon_by_filetype(filetype, { default = true })
  end

  return string.format("%%#%s#%s%%#Title#%s%%#Normal#", icon_hl, icon, filetype)
end

--- Get all running LSP servers and copilot status
--- @return string[] lsp_server_names
--- @return boolean is_copilot_active
local function get_lsp_info()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    return {}, false
  end

  local lsp_info = require("core.constants").lsps
  table.sort(clients, function(a, b)
    local a_priority = lsp_info[a.name or "LSP"] and lsp_info[a.name or "LSP"].priority or 0
    local b_priority = lsp_info[b.name or "LSP"] and lsp_info[b.name or "LSP"].priority or 0
    return a_priority > b_priority
  end)

  local client_info = vim.iter(clients):fold({}, function(acc, client)
    local name = lsp_info[client.name] and lsp_info[client.name].name or client.name
    table.insert(acc, name)
    return acc
  end)

  -- We exclude Copilot LSP from LSP count
  local updated_client_info = vim.tbl_filter(function(name)
    return name ~= "copilot"
  end, client_info)

  return updated_client_info, #client_info ~= #updated_client_info
end

--- Show LSP clients in the statusline
--- @param server_names string[] List of LSP servers attached
function M.lsp_component(server_names)
  if #server_names == 0 then
    return ""
  end

  local lsp_str = server_names[1]

  if #server_names > 1 then
    lsp_str = lsp_str .. ("+%s"):format(#server_names - 1)
  end

  return lsp_str
end

--- The current line, total line count, and column position.
---@return string
function M.position_component()
  local line = vim.fn.line "."
  local line_count = vim.api.nvim_buf_line_count(0)
  local col = vim.fn.virtcol "."

  return table.concat {
    "%#StatuslineItalic#l: ",
    string.format("%%#Title#%d", line),
    string.format("%%#Italic#/%d c: %d", line_count, col),
    "%#Normal#",
  }
end

M.toggle_copilot = function()
  vim.cmd "Copilot toggle"
  vim.cmd "redrawstatus"
end

M.search_count = function()
  if vim.v.hlsearch == 0 then
    return ""
  end

  local ok, count = pcall(vim.fn.searchcount, { recompute = true, maxcount = 500 })
  if (not ok or (count.current == nil)) or (count.total == 0) then
    return ""
  end

  if count.incomplete == 1 then
    return "?/?"
  end

  local too_many = (">%d"):format(count.maxcount)
  local total = (count.total > count.maxcount) and too_many or count.total

  return ("%s/%s"):format(count.current, total)
end

---Render the statusline
---@return string
M.render = function()
  local _, mode_hl, inverted_mode_hl = unpack(get_mode_info())
  local lsp_servers, is_copilot_active = get_lsp_info()
  local lsp_str = M.lsp_component(lsp_servers)
  local git_branch = M.git_branch()

  local copilot_clickable = table.concat {
    "%@v:lua.require'statusline'.toggle_copilot@",
    is_copilot_active and "   " or "   ",
    "%T",
  }

  local rec = vim.fn.reg_recording()
  local macro_recording = rec ~= "" and (" ⏺ recording @" .. rec .. " ") or ""

  local left_expression = {
    apply_hl(" ", mode_hl),
    ah(M.filename_component(), inverted_mode_hl),
    ah(M.diagnostics_component(), "Normal"),
  }

  local right_expression = {
    ah(M.search_count(), "IncSearch"),
    macro_recording,
    apply_hl(copilot_clickable, is_copilot_active and "Normal" or "Comment"),
    ah(lsp_str, "MiniStatuslineModeOther"),
    ah(git_branch, inverted_mode_hl),
  }

  -- The LSP comes with it's own big chonk so
  -- we only add empty when it's not there
  if lsp_str == "" or git_branch ~= "" then
    table.insert(right_expression, apply_hl(" ", mode_hl))
  end

  return table.concat {
    table.concat(left_expression),
    "%#StatusLine#%=",
    table.concat(right_expression),
  }
end

--- This has to be scheduled in this order so that the statusline can pick it up after
vim.schedule(function()
  for _, mode in pairs(mode_info) do
    inverted_hl(mode.hl)
  end
end)

return M
