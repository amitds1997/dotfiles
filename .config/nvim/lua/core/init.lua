local g, api = vim.g, vim.api

-- Set leader
g.mapleader = " "
api.nvim_set_keymap("n", " ", "", { noremap = true })
api.nvim_set_keymap("x", " ", "", { noremap = true })

-- Disable built-in plugins
local default_plugins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "syntax",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}
for _, plugin in ipairs(default_plugins) do
  g["loaded_" .. plugin] = 1
end

require("core.options")
require("core.pack"):bootstrap()
require("core.keymappings")
require("core.event")
