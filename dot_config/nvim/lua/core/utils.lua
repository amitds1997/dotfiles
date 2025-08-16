local U = {}

function U.create_augroup(name, clear)
  if clear == nil then
    clear = true
  end
  return vim.api.nvim_create_augroup("amitds1997/" .. name, { clear = clear })
end

function U.debounce(ms, fn)
  local timer = vim.uv.new_timer()
  return function(...)
    local argv = { ... }

    if not timer then
      vim.notify("Failed to create a timer", vim.log.levels.ERROR)
      return
    end

    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

---Set keymap for action
---@param lhs string Key combinations that would activate the keymap
---@param rhs function|string Action to take when the keymap is activated
---@param desc string Description of what the keymap would do
---@param mode? string|table Modes in which this keymap should be registered
function U.set_keymap(lhs, rhs, desc, mode)
  mode = mode or "n"
  vim.validate("mode", mode, { "string", "table" })
  vim.validate("desc", desc, "string")
  vim.keymap.set(mode, lhs, rhs, { desc = desc, noremap = true })
end

--- Get the file size of a buffer in a human-readable format
---@param bufnr number|nil Buffer number. If nil, uses the current buffer.
function U.get_filesize(bufnr)
  local size = math.max(vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr or 0)), 0)
  if size < 1024 then
    return string.format("%dB", size)
  elseif size < 1048576 then
    return string.format("%.2fKiB", size / 1024)
  else
    return string.format("%.2fMiB", size / 1048576)
  end
end

--- Print information about all open windows in the current Neovim instance
function U.print_windows_info()
  print "WinID | Buf | Tab | Pos(row,col) | Size(w,h)"
  print "--------------------------------------------"
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local tab = vim.api.nvim_win_get_tabpage(win)
    local row, col = unpack(vim.api.nvim_win_get_position(win))
    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)
    print(string.format("%5d | %3d | %3d | (%2d,%2d)      | (%2d,%2d)", win, buf, tab, row, col, width, height))
  end
end

return U
