local bo = vim.bo
local opt_local = vim.opt_local

opt_local.number = false
opt_local.relativenumber = false
opt_local.cursorline = false
opt_local.wrap = false
opt_local.linebreak = false
opt_local.statuscolumn = ""

opt_local.showbreak = ""
opt_local.smoothscroll = false
opt_local.foldmethod = "manual"

bo.undofile = false
opt_local.spell = false
opt_local.conceallevel = 0
opt_local.concealcursor = ""

bo.autoindent = false
bo.smartindent = false
bo.expandtab = false
bo.softtabstop = 0
bo.shiftwidth = 8
opt_local.shiftround = false

opt_local.breakindent = false
opt_local.breakindentopt = ""
opt_local.virtualedit = ""

if vim.fn.exists ":NoMatchParen" ~= 0 then
  vim.cmd "NoMatchParen"
end

bo.syntax = "off"
vim.diagnostic.enable(false, { bufnr = 0 })

-- Set a custom statusline (window-local)
opt_local.statusline = ("Big File: %d lines, %s"):format(
  vim.api.nvim_buf_line_count(0),
  require("core.utils").get_filesize(0)
)

vim.schedule(function()
  bo.syntax = vim.filetype.match { buf = 0 } or ""
end)
