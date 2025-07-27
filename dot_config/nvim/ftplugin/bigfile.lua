-- Set local (buffer or window scoped) options
local bo = vim.bo -- buffer-local
local opt_local = vim.opt_local -- unified opt_local where allowed

-- Performance killers (mostly window-local)
opt_local.number = false
opt_local.relativenumber = false
opt_local.cursorline = false
opt_local.wrap = false
opt_local.linebreak = false
opt_local.statuscolumn = ""

-- Some window-local options (opt_local version)
opt_local.showbreak = ""
opt_local.smoothscroll = false
opt_local.foldmethod = "manual"

-- Buffer-local options
bo.undofile = false
opt_local.spell = false
opt_local.conceallevel = 0
opt_local.concealcursor = ""

-- Disable indentation-related processing (buffer-local)
bo.autoindent = false
bo.smartindent = false
bo.expandtab = false
bo.softtabstop = 0
bo.shiftwidth = 8
opt_local.shiftround = false

-- These are window-local
opt_local.breakindent = false
opt_local.breakindentopt = ""
opt_local.virtualedit = ""

-- Disable matchparen (plugin command, not an option)
if vim.fn.exists ":NoMatchParen" ~= 0 then
  vim.cmd "NoMatchParen"
end

-- Disable syntax highlighting (this API call is correct)
bo.syntax = "off"

-- Disable diagnostics (LSP signs, underline, virtual_text)
vim.diagnostic.enable(false, { bufnr = 0 })

-- Set a custom statusline (window-local)
opt_local.statusline = ("Big File: %d lines, %.2f MB"):format(
  vim.api.nvim_buf_line_count(0),
  vim.fn.getfsize(vim.api.nvim_buf_get_name(0)) / 1e6
)

-- Disable matchparen again, probably redundant but left in case plugin re-enables
if vim.fn.exists ":NoMatchParen" ~= 0 then
  vim.cmd [[NoMatchParen]]
end

-- Delay restoring filetype/syntax (useful if disabled above for performance)
vim.schedule(function()
  bo.syntax = vim.filetype.match { buf = 0 } or ""
end)
