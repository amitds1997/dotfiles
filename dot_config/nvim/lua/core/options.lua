local o, g = vim.opt, vim.g
local utils = require("core.utils")

-- Set mapleader
g.mapleader = " "
g.maplocalleader = " "
vim.keymap.set({ "n", "x", "v" }, g.mapleader, "", { noremap = true })

-- Disable loading extra providers
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

o.history = 2000 -- History retains last n cmdline and search commands
o.ruler = true -- Need no ruler
o.swapfile = false -- We do not need swap files
o.mouse = "a" -- Enable mouse control for all modes
o.number = true -- Show line number
o.relativenumber = true -- Show relative numbers
o.hidden = true -- Hide buffers instead of closing them when switching to another
o.showmode = false -- Do not show messages on last line; this is anyway disabled by cmdheight
o.cmdheight = 0 -- Hide command bar when not used
o.showtabline = 1 -- Never show tabline
o.signcolumn = "yes" -- Show sign column
o.shortmess = "costlFACTIO" -- Avoid hit-enter file prompts
o.fcs = "eob: " -- Hide the ~ character at the end of buffer
o.termguicolors = true -- Enable 24-bit colors
o.laststatus = 0 -- We disable statusline here. It gets overriden by lualine
o.autoread = true -- Automatically read changes in file if they happen outside Neovim
o.errorbells = false -- No error bells please
-- o.conceallevel = 3 -- Hide concealed characters
o.clipboard = "unnamedplus" -- Use "unnamedplus" register for copy-paste things
o.undofile = true -- Save undo tree to a file
o.virtualedit = "block" -- Allow virtual editing in visual block mode

-- Set mapped key sequence timeouts
o.timeout = true
o.timeoutlen = 300

-- Render invisible characters
o.list = true
o.listchars = "tab:» ,nbsp:+,trail:·,extends:→,precedes:←"

-- o.formatoptions = "qjl1" -- Don't autoformat comments
o.formatoptions:remove("o") -- Don't have `o`/`O` add comments

-- Window options
o.winwidth = 30 -- Minimum columns per window
o.winblend = 0 -- Needed to create transparent windows

-- Fold options
-- o.foldmethod = "expr" --'foldexpr' determines the fold level of a line.
-- o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 99 -- Start with no folds
o.foldlevelstart = 99 -- Start with no folds
o.foldnestmax = 10 -- Deepest fold is 10 levels
o.foldenable = true -- Don't fold by default
o.foldcolumn = "1" -- Do not show fold column

-- Tab control
o.expandtab = true -- Expand <Tab> into spaces
o.smarttab = true -- <Tab> respects 'tabstop', 'shiftwidth', and 'softtabstop'
o.softtabstop = 2 -- Number of spaces <Tab> counts for in editing operations
o.tabstop = 2 -- <Tab> counts for 2 spaces

-- Indent options
o.autoindent = true
o.smartindent = true
o.shiftwidth = 2 -- Number of spaces for each step of (auto) indent
o.shiftround = true -- Round indent to a multiple of 'shiftwidth'
o.breakindent = true -- Wrapped lines indent visually aligned
o.breakindentopt = "min:20,sbr"
o.smoothscroll = true -- Turn on smooth scrolling

-- Show matching brace
o.showmatch = true -- Briefly jump to the matching bracket
o.matchtime = 2 -- Show it for (n/10)th of a second

-- Enable spellcheck
o.spell = false -- Disable spellchecking (we can toggle this using <leader>cs keymap)
o.spelllang = "en_us" -- Use US English for completions
o.spelloptions = "camel" -- In camel-cased words, each camel case denotes a new word
o.spellfile = utils.path_join(vim.fn.stdpath("config"), "spell", "en.utf-8.add")

-- Split behavior
o.splitbelow = true -- If horizontal, split below
o.splitright = true -- If vertical, split right
o.splitkeep = "cursor" -- Keep the same relative cursor position

-- Command line completions
o.wildmenu = true -- Give me completions on command-line
o.wildignorecase = true -- Ignore case when completing file names and directories
o.wildoptions = "fuzzy,pum" -- Fuzzy match completions

-- Completions
-- o.infercase = true
o.completeopt = { "menu", "menuone", "noselect" } -- Completion menu style

-- Keep my cursor away from the end
o.scrolloff = 4 -- Stay 4 lines away from top-bottom border
o.sidescrolloff = 8 -- Stay 8 characters away from left-right border

-- Search and substitute options
o.hlsearch = true
o.incsearch = true
o.ignorecase = true -- Ignore case when searching
o.smartcase = true -- Follow ignore case unless there is a capital, then case-sensitive
o.tagcase = "followscs" -- When searching tag files, follow smartcase
o.inccommand = "split" -- Show substitutions in a partial off-window

-- Wrapping options
o.wrap = true
o.showbreak = "↪" -- String at start of warped lines
o.linebreak = true -- Do soft wrapping instead of hard wrapping

-- Pop-up menu options
o.pumblend = 0 -- Needed for pseudo-transparency
o.pumheight = 10 -- Show 10 items in the pop-up menu

-- Cursor line options
o.cursorline = true
o.cursorlineopt = "number"

o.fillchars = {
  eob = " ",
  foldopen = "󰅀",
  foldclose = "󰅂",
  fold = " ",
  foldsep = " ",
}
o.backup = false -- Don't store backup while overwriting the file
o.writebackup = false -- Don't store backup while overwriting the file

o.autowrite = true
o.autowriteall = true

-- If we have rg installed, use rg to grep
if vim.fn.executable("rg") == 1 then
  o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
  o.grepprg = "rg --vimgrep --no-heading --smart-case"
end
