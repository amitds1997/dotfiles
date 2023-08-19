local api, fn = vim.api, vim.fn
local devicons = require("nvim-web-devicons")
local Menu = require("nui.menu")
local NuiLine = require("nui.line")

local M = {}

local function get_icon_by_filetype(bufnr)
  local icon, hl = devicons.get_icon_by_filetype(vim.bo[bufnr].filetype, { default = true })
  return icon .. " ", hl
end

local function buf_file_name(bufnr)
  local name = fn.bufname(bufnr)
  if bufnr == "" then
    name = "[No Name]"
  end
  return name
end

local function get_buffers()
  local bufnrs = fn.getbufinfo({ buflisted = 1 })

  -- We want buffers sorted by their last used time
  table.sort(bufnrs, function (a, b)
    return a.lastused > b.lastused
  end)

  local buffers = {}
  for _, bufnr in ipairs(bufnrs) do
    local elem = {
      bufnr = bufnr.bufnr,
      filename = buf_file_name(bufnr.bufnr)
    }
    if bufnr == fn.bufnr("%") then     -- Current buffer
      table.insert(buffers, 1, elem)
    elseif bufnr == fn.bufnr("#") then -- Previous buffer to current
      table.insert(buffers, 2, elem)
    else                               -- Any other listed buffer
      table.insert(buffers, elem)
    end
  end

  return buffers
end

function M.get_buffer_menu()
  local buffers = fn.getbufinfo({ buflisted = 1 })
  if #buffers <= 1 then
    return
  elseif #buffers == 2 then
    local idx = buffers[1].bufnr == fn.bufnr("%") and 2 or 1
    api.nvim_win_set_buf(0, buffers[idx].bufnr)
  else
    buffers = get_buffers()
    local lines = {}
    local max_length = 0
    for idx, buffer in ipairs(buffers) do
      local file_icon = get_icon_by_filetype(buffer.bufnr)
      local file = ("[%02d] %s %s"):format(idx, file_icon, buffer.filename)
      max_length = math.max(max_length, #file)
      table.insert(lines, Menu.item(file, { bufnr = buffer.bufnr }))
    end

    local min_window_size = 20
    local popup_options = {
      position = "50%",
      size = {
        width = math.max(max_length, min_window_size),
      },
      border = {
        style = "rounded",
        text = {
          top = " Choose buffer ",
          top_align = "center",
        },
      },
      win_options = {
        winblend = 0,
        cursorlineopt = "line",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Bold",
      },
    }

    local menu = Menu(popup_options, {
      lines = lines,
      keymap = {
        focus_next = { "j", "<Down>", "<Tab>" },
        focus_prev = { "k", "<Up>", "<S-Tab>" },
        close = { "<Esc>", "<C-c>", "q" },
        submit = { "<CR>", "<Space>" },
      },
      on_change = function (item, _)
        local line = NuiLine()
        line:append(item, "ErrorMsg")
        return line
      end,
      on_submit = function (item)
        api.nvim_win_set_buf(0, item.bufnr)
      end,
    })

    -- mount the component
    menu:mount()
  end
end

return M
