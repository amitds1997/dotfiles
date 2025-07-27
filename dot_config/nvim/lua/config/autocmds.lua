local create_augroup = function(name)
  return vim.api.nvim_create_augroup("amitds1997/core/" .. name, { clear = true })
end

-- Remove padding around Neovim in terminal when background is not transparent
if not require("settings").colorscheme.transparent_background then
  local transparency_augroup = create_augroup "transparency"

  vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
    group = transparency_augroup,
    desc = "Handle terminal transparency",
    callback = function()
      local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
      if not normal.bg then
        return
      end
      io.write(string.format("\027]11;#%06x\027\\", normal.bg))
    end,
  })

  vim.api.nvim_create_autocmd("UILeave", {
    group = transparency_augroup,
    callback = function()
      io.write "\027]111\027\\"
    end,
  })
end

-- Close and delete (if possible) metadata files that are just information/read-only with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = create_augroup "fast_quit",
  pattern = require("settings").meta_filetypes,
  desc = "Close metadata files with <q>",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", function()
      vim.cmd "close"
      pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
    end, { buffer = event.buf, silent = true, desc = "Quit buffer" })
  end,
})

-- Wrap and check for spell in the text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = create_augroup "wrap_spell",
  pattern = { "text", "markdown", "gitcommit", "plaintex", "typst" },
  desc = "Enable wrap and spell for text filetypes",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Clean up `viewdir` and `undodir` files older than 30 days
vim.api.nvim_create_autocmd({ "FocusLost" }, {
  group = create_augroup "cleanup_old_files",
  desc = "Clean up old files in viewdir and undodir",
  once = true,
  callback = function()
    local view_dir = vim.fs.joinpath(vim.fn.stdpath "state", "view")
    local undo_dir = vim.fs.joinpath(vim.fn.stdpath "state", "undo")

    vim.system { "find", view_dir, "-mtime", "+30d", "-delete" }
    vim.system { "find", undo_dir, "-mtime", "+30d", "-delete" }
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = create_augroup "yank_highlight",
  desc = "Highlight text on being yanked",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Resize splits when the window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = create_augroup "resize_splits",
  desc = "Resize splits when the window is resized",
  callback = function()
    local current_tab = vim.api.nvim_get_current_tabpage()
    vim.cmd "tabdo wincmd ="
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Jump to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = create_augroup "jump_to_last_location",
  desc = "Jump to last location when opening a buffer",
  callback = function(event)
    local excluded_filetypes = { "NvimTree", "Trouble", "TelescopePrompt", "help", "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Fix conceallevel for JSON files
vim.api.nvim_create_autocmd("FileType", {
  group = create_augroup "json_conceal",
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})

-- LSP Progress
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  desc = "Handle LSP progress notifications",
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
    vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
