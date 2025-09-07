local U = {}

---@module "lazy"
---@type LazyFloat?
local terminal = nil

local float_sizes = {}

function U.float_term(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    ft = "lazyterm",
    size = { width = 0.7, height = 0.7 },
    persistent = true,
  }, opts or {})

  if terminal and terminal:buf_valid() and vim.b[terminal.buf].lazyterm_cmd == cmd then
    terminal:toggle()
  else
    terminal = require("lazy.util").float_term(cmd, opts)
    vim.b[terminal.buf].lazyterm_cmd = cmd
  end
end

function U.maximize_float_win(win_id)
  win_id = win_id or vim.api.nvim_get_current_win()
  local config = vim.api.nvim_win_get_config(win_id)

  if config.relative == "" then
    vim.notify("Window is not a floating window", vim.log.levels.WARN)
    return
  end

  if float_sizes[win_id] then
    vim.api.nvim_win_set_config(win_id, float_sizes[win_id])
    float_sizes[win_id] = nil
  else
    float_sizes[win_id] = config

    vim.api.nvim_win_set_config(win_id, {
      relative = "editor",
      width = vim.o.columns,
      height = vim.o.lines - 2,
      row = 0,
      col = 0,
    })
  end
end

return U
