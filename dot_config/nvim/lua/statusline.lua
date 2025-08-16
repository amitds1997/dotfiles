local M = {}

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

function M.mode_component()
  local mode = vim.api.nvim_get_mode().mode
  local info = mode_info[mode] or { name = mode, hl = "MiniStatuslineModeOther" }
  return "%#" .. info.hl .. "# " .. info.name .. " %#Normal#"
end

function M.filename_component()
  if vim.bo.buftype == "terminal" then
    return "%t"
  end

  return "%F%m%r"
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

-- Show LSP clients in the statusline
function M.lsp_component()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    return ""
  end

  local lsp_info = require("core.constants").lsps
  table.sort(clients, function(a, b)
    local a_priority = lsp_info[a.name or "LSP"] and lsp_info[a.name or "LSP"].priority or 0
    local b_priority = lsp_info[b.name or "LSP"] and lsp_info[b.name or "LSP"].priority or 0
    return a_priority > b_priority
  end)

  local client_info = vim.iter(clients):fold({}, function(acc, client)
    local name = lsp_info[client.name] and lsp_info[client.name].name or client.name
    table.insert(acc, { name = name, hl = "MiniStatuslineDevInfo" })
    return acc
  end)

  local major_lsp = client_info[1]
  local lsp_str = "%#" .. major_lsp.hl .. "# " .. major_lsp.name
  if #client_info > 1 then
    lsp_str = lsp_str .. ("+%s"):format(#client_info - 1)
  end

  return lsp_str .. " %#Normal#"
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

---Render the statusline
---@return string
M.render = function()
  ---@param components string[]
  ---@return string
  local function concat_components(components)
    return vim.iter(components):skip(1):fold(components[1], function(acc, component)
      return #component > 0 and string.format("%s %s", acc, component) or acc
    end)
  end
  return table.concat {
    concat_components { M.mode_component(), M.filename_component(), M.diagnostics_component() },
    "%#StatusLine#%=",
    concat_components { M.lsp_component(), M.position_component() },
  }
end

vim.o.statusline = "%!v:lua.require'statusline'.render()"

return M
