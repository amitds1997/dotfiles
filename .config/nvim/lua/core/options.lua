local opt, g = vim.o, vim.g
local utils = require("core.utils")
local cache_dir = vim.fn.stdpath("cache")

g.mapleader = " "
vim.keymap.set({ "n", "x", "v" }, " ", "", { noremap = true })

opt.autoindent = true
opt.autoread = true
opt.backup = false
-- TODO: Do I need this after turning off backup?
opt.backupdir = utils.path_join(cache_dir, "backup", utils.path_sep)
-- TODO: Figure out why this does?
opt.breakindentopt = "shift:2,min:20"
-- TODO: Figure out the correct value for this
opt.clipboard = "unnamedplus"
opt.cmdheight = 0
-- TODO: Should preview be included?
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3
-- TODO: Do we use swap files? Do I have a need for this?
opt.directory = utils.path_join(cache_dir, "swap", utils.path_sep)
opt.errorbells = false
opt.expandtab = true
opt.foldlevelstart = 99
-- TODO: What is the ideal value for this?
opt.foldmethod = "marker"
opt.hidden = true
opt.history = 2000
opt.hlsearch = true
-- TODO: See 'tagcase' and 'smartcase'
opt.ignorecase = true
opt.incsearch = true
opt.infercase = true
opt.laststatus = 3
-- TODO: What is this? Is this needed?
opt.linebreak = true
opt.list = true
opt.listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←"
opt.magic = true
opt.matchtime = 5
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
-- TODO: How should we adjust this
opt.pumblend = 10
-- TODO: How should we adjust this
opt.pumheight = 10
opt.redrawtime = 2000
opt.ruler = false
-- TODO: Should we set this to max so that we are always in the middle
opt.scrolloff = 4
opt.shiftwidth = 2
-- TODO: Any changes here?
opt.shortmess = "acoACFIOT"
opt.showcmd = true
-- TODO: See 'cpoptions'
opt.showmatch = true
opt.showmode = false
-- TODO: What does this do?
opt.showtabline = 0
-- TODO: Should set to a very large value?
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.smarttab = true
opt.softtabstop = 2
-- TODO: Any other spellcheck options?
opt.spelloptions = "camel"
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.swapfile = false
-- TODO: See :retab
opt.tabstop = 2
-- TODO: Should this be wrapped?
opt.termguicolors = true
opt.timeout = true
-- TODO: What is a good value for this?
opt.timeoutlen = 500
opt.ttimeout = true
-- TODO: What should be a good value for this?
opt.ttimeoutlen = 10
-- TODO: Best practices for undo?
opt.undodir = utils.path_join(cache_dir, "undo", utils.path_sep)
opt.undofile = true
opt.updatetime = 100
-- TODO: What does this do???
opt.viewdir = utils.path_join(cache_dir, "view", utils.path_sep)
-- TODO: What does this do??
opt.virtualedit = "block"
-- TODO: How to best set this and unitilze this
opt.whichwrap = "b,s,<,>,[,],~"
-- TODO: Best values for this?
opt.wildignorecase = true
-- TODO: Set wildoptions? wildmode? wildignore?
opt.wildmenu = true
opt.winblend = 10
-- TODO: What is a good value for this?
opt.winwidth = 30
-- TODO: Ideal options when doing this?
opt.wrap = true
-- TODO: What other options along with this make sense?
opt.writebackup = false
vim.wo.showbreak = "NONE"

-- Set these so that transparency does not break
opt.cursorline = true
opt.cursorlineopt = "number"
opt.winblend = 0
opt.pumblend = 0

-- Disable loading extra providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- If we have rg installed, use rg to grep
if vim.fn.executable("rg") == 1 then
  opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
end

-- TODO: Better logic here??
if vim.uv.os_uname().sysname == "Darwin" then
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
