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

--- Toggle a window full screen
---@param win_id number
---@return boolean is_zoomed_in If the window is zoomed in
function U.toggle_full_screen(win_id)
  if not win_id then
    win_id = 0
  end

  return require("mini.misc").zoom(win_id, {
    title = vim.api.nvim_buf_get_name(win_id),
  })
end

return U
