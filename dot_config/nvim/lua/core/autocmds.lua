local create_augroup = require("core.utils").create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Remove padding around Neovim in terminal when background is not transparent
if not require("settings").colorscheme.transparent_background then
  local transparency_augroup = create_augroup "transparency"

  autocmd({ "UIEnter", "ColorScheme" }, {
    group = transparency_augroup,
    desc = "Handle terminal transparency",
    callback = function()
      local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
      if not normal.bg then
        return
      end
      io.write(string.format("\027]11;#%06x\007\\", normal.bg))
    end,
  })

  autocmd("UILeave", {
    group = transparency_augroup,
    callback = function()
      io.write "\027]111\007\\"
    end,
  })
end

-- Close and delete (if possible) metadata files that are just information/read-only with <q>
autocmd("FileType", {
  group = create_augroup "fast_quit",
  pattern = require("settings").meta_filetypes,
  desc = "Close metadata files with `q`",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", function()
      if vim.fn.winnr "$" == 1 then
        vim.cmd "quit"
        return
      end
      vim.cmd "close"
      pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
    end, { buffer = event.buf, silent = true, desc = "Quit buffer" })
  end,
})

-- Clean up `viewdir` and `undodir` files older than 30 days
autocmd({ "FocusLost" }, {
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
autocmd("TextYankPost", {
  group = create_augroup "yank_highlight",
  desc = "Highlight text on being yanked",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Resize splits when the window is resized
autocmd("VimResized", {
  group = create_augroup "resize_splits",
  desc = "Resize splits when the window is resized",
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

-- Jump to last location when opening a buffer
autocmd("BufReadPost", {
  group = create_augroup "jump_to_last_location",
  desc = "Jump to last location when opening a buffer",
  callback = function(event)
    local buf = event.buf
    local excluded_filetypes = require("settings").last_location_excluded_filetypes

    if (buf ~= vim.api.nvim_get_current_buf()) or vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype) then
      return
    end

    local last_cursor_position_mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)
    if last_cursor_position_mark[1] > 0 and last_cursor_position_mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, last_cursor_position_mark)
    end
  end,
})

-- Never conceal for JSON files
autocmd("FileType", {
  group = create_augroup "json_conceal",
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Show cursor line only in active window
autocmd({ "InsertLeave", "WinEnter" }, {
  group = create_augroup "auto_cursorline_show",
  callback = function(event)
    if vim.bo[event.buf].buftype == "" then
      vim.opt_local.cursorline = true
    end
  end,
})
autocmd({ "InsertEnter", "WinLeave" }, {
  group = create_augroup "auto_cursorline_hide",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Display a warning when the current file is not in UTF-8 format
autocmd({ "BufRead" }, {
  pattern = "*",
  group = create_augroup "non_utf8_file",
  callback = function()
    if not vim.tbl_contains({ "utf-8", "" }, vim.bo.fileencoding) then
      vim.notify("File not in UTF-8 format!", vim.log.levels.WARN, { title = "UTF-8 Warning" })
    end
  end,
})

-- Remember folds for files
local auto_view_group = create_augroup "auto_view"
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  group = auto_view_group,
  desc = "Save view with mkview for real files",
  callback = function(args)
    if args.buf ~= vim.api.nvim_get_current_buf() then
      return
    end
    if vim.b[args.buf].view_activated then
      vim.cmd.mkview { mods = { emsg_silent = true } }
    end
  end,
})
autocmd("BufWinEnter", {
  group = auto_view_group,
  desc = "Try to load file view if available and enable view saving for real files",
  callback = function(args)
    if not vim.b[args.buf].view_activated then
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
      if
        buftype == ""
        and filetype
        and filetype ~= ""
        and not vim.tbl_contains(require("settings").meta_filetypes, filetype)
      then
        vim.b[args.buf].view_activated = true
        vim.cmd.loadview { mods = { emsg_silent = true } }
      end
    end
  end,
})
