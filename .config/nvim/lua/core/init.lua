local g, api = vim.g, vim.api

-- Set leader
g.mapleader = " "
api.nvim_set_keymap("n", " ", "", { noremap = true })
api.nvim_set_keymap("x", " ", "", { noremap = true })

require("core.options")
require("core.lazy"):bootstrap()
require("core.keymappings")
require("core.event")
