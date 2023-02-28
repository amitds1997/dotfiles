local opt = vim.o
local utils = require("core.utils")
local cache_dir = vim.fn.stdpath("cache")

opt.autoindent = true
opt.autoread = true
opt.backup = false
opt.backupdir = utils.path_join(cache_dir, "backup", utils.path_sep)
opt.breakindentopt = "shift:2,min:20"
opt.clipboard = "unnamedplus"
opt.cmdheight = 0
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3
opt.cursorline = true
opt.directory = utils.path_join(cache_dir, "swap", utils.path_sep)
opt.errorbells = false
opt.expandtab = true
opt.foldlevelstart = 99
opt.foldmethod = "marker"
opt.hidden = true
opt.history = 2000
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.infercase = true
opt.laststatus = 3
opt.linebreak = true
opt.list = true
opt.listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←"
opt.magic = true
opt.matchtime = 2
opt.mouse = "a"
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.redrawtime = 1500
opt.ruler = false
opt.scrolloff = 4
opt.shiftwidth = 2
opt.shortmess = "oOTIcFCs"
opt.showcmd = true
opt.showmatch = true
opt.showmode = false
opt.showtabline = 0
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.smarttab = true
opt.softtabstop = 2
opt.spelloptions = "camel"
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeout = true
opt.ttimeoutlen = 10
opt.undodir = utils.path_join(cache_dir, "undo", utils.path_sep)
opt.undofile = true
opt.updatetime = 100
opt.viewdir = utils.path_join(cache_dir, "view", utils.path_sep)
opt.virtualedit = "block"
opt.whichwrap = "b,s,<,>,[,],~"
opt.wildignorecase = true
opt.wildmenu = true
opt.winblend = 10
opt.winwidth = 30
opt.wrap = true
opt.writebackup = false
vim.wo.showbreak = "NONE"

-- If we have rg installed, use rg to grep
if vim.fn.executable("rg") == 1 then
  opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
end

if vim.loop.os_uname().sysname == "Darwin" then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }
end
