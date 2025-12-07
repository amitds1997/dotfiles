local o, g = vim.opt, vim.g

------------------------------------------
-- 🚀 Performance & Startup
------------------------------------------
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

------------------------------------------
-- ⚙️ General Behavior
------------------------------------------
o.history = 2000 -- Command line history size
o.swapfile = false -- Do not create swap files
o.updatetime = 500 -- Faster update time for plugins and events
o.timeout = true -- Use timeout for mapped key sequences
o.timeoutlen = 300 -- Time in ms to wait for a mapped sequence to complete
o.autowrite = true -- Automatically write files when switching buffers
o.autowriteall = true -- Same as above, but for more commands
o.undofile = true -- Persist undo history across sessions

------------------------------------------
-- ✨ UI & Appearance
------------------------------------------
o.termguicolors = true -- Enable 24-bit RGB colors
o.number = true -- Show line numbers
o.relativenumber = true -- Show relative line numbers
o.signcolumn = "yes" -- Always show the sign column
o.cursorline = true -- Highlight the current line
o.cursorlineopt = "both" -- Highlight both the screen line and the line number
o.conceallevel = 2 -- Hide markup characters (e.g., in Markdown)
o.laststatus = 3 -- Use a global statusline
o.statuscolumn = [[%!v:lua.require'custom.statuscolumn'.get()]]
o.showtabline = 1 -- Show tabline only when there are at least 2 tabs
o.cmdheight = 0 -- Hide the command bar
o.ruler = true -- Show the ruler
o.showmode = false -- Don't show the current mode (e.g., -- INSERT --)
o.pumheight = 10 -- Pop-up menu height
o.pumblend = 2 -- Transparency for the pop-up menu
o.winblend = 0 -- Transparency for floating windows
o.scrolloff = 4 -- Keep 4 lines visible above/below the cursor
o.sidescrolloff = 8 -- Keep 8 columns visible left/right of the cursor
o.list = true -- Show invisible characters
o.listchars = { tab = "•·❯", trail = "·", extends = "→", precedes = "←", nbsp = "␣" }
o.showmatch = true -- Briefly jump to matching brackets
o.matchtime = 2 -- Show match for 0.2 seconds
o.fillchars = {
  eob = " ", -- Character for end of buffer
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
}
o.shortmess:append {
  c = true,
  o = true,
  s = true,
  t = true,
  F = true,
  A = true,
  C = true,
  T = true,
  O = true,
  I = true,
  l = true,
}

------------------------------------------
-- 📁 Folding
------------------------------------------
o.foldenable = true -- Enable folding
o.foldlevel = 99 -- Start with all folds open
o.foldlevelstart = 99 -- Folds are open when you open a file
o.foldnestmax = 10 -- Maximum nesting of folds
o.foldcolumn = "1" -- Show a 1-character wide fold column

------------------------------------------
-- 🔍 Search & Completion
------------------------------------------
o.hlsearch = true -- Highlight all matches on search
o.incsearch = true -- Show search results as you type
o.ignorecase = true -- Ignore case in search patterns
o.smartcase = true -- Override 'ignorecase' if the search pattern contains uppercase letters
o.inccommand = "split" -- Show substitution results in a preview window
o.tagcase = "followscs" -- When searching tag files, follow smartcase
o.wildmenu = true -- Visual autocomplete for command-line
o.wildignorecase = true -- Ignore case when completing file names
o.wildoptions = "fuzzy,pum" -- Use fuzzy matching and a popup menu for completion
o.completeopt = { "menu", "menuone", "noselect" } -- Set completion options

------------------------------------------
-- 🖥️ Window & Split Management
------------------------------------------
o.splitbelow = true -- A horizontal split creates a new window below the current one
o.splitright = true -- A vertical split creates a new window to the right
o.splitkeep = "cursor" -- Keep the cursor in the same relative position
o.equalalways = true -- Windows are always resized to be equal

------------------------------------------
-- ✍️ Spellcheck
------------------------------------------
o.spell = false
o.spelllang = "en_us"
o.spelloptions = "camel" -- Treat parts of camelCase words as separate words
o.spellfile = vim.fs.joinpath(vim.fn.stdpath "config", "spell", "en.utf-8.add")

------------------------------------------
-- 📋 System Integration & Files
------------------------------------------
o.clipboard = "unnamedplus" -- Use system clipboard for copy/paste
o.errorbells = false -- No beeping
o.hidden = true -- Allow hidden buffers
o.backup = false -- Don't store backup files
o.writebackup = false -- Don't store backup files

-- Use ripgrep for searching if it's available.
if vim.fn.executable "rg" == 1 then
  o.grepprg = "rg --vimgrep --no-heading --smart-case --hidden -g '!.git/*'"
  o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Handle clipboard copy over SSH using OSC 52 protocol.
if vim.g.remote_neovim_host then
  vim.g.clipboard = "osc52"
end

------------------------------------------
-- 📝 Text Editing & Indentation
------------------------------------------
o.expandtab = true -- Use spaces instead of tabs
o.tabstop = 2 -- Number of spaces a <Tab> in a file counts for
o.softtabstop = 2 -- Number of spaces to insert for a <Tab>
o.autoindent = true -- Copy indent from the current line when starting a new line
o.shiftwidth = 2 -- Number of spaces for each step of (auto)indent
o.breakindentopt = "min:20,sbr"
o.smartindent = true -- Be smart about indentation
o.wrap = true -- Wrap long lines
o.mouse = "a" -- Enable mouse support in all modes

------------------------------------------
-- ⏳ Deferred (Lazy-Loaded) Options
------------------------------------------
-- These options are expensive and are set only after plugins have loaded
-- (triggered by the "VeryLazy" event) to ensure a fast startup.
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    o.linebreak = true -- Wrap lines at convenient points (e.g., after a word)
    o.showbreak = "↪ " -- Character to show at the start of wrapped lines
    o.autoread = true -- Automatically reload files when changed on disk
    o.smoothscroll = true -- Enable smooth scrolling
    o.breakindent = true -- Wrapped lines maintain indentation
    o.shiftround = true -- Round indent to a multiple of 'shiftwidth'
    o.virtualedit = "block" -- Allow the cursor to move where there is no text
    o.winborder = "rounded" -- Round borders for all windows
  end,
})
