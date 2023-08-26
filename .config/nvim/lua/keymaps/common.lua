return {
  ["<ESC>"] = { "<cmd>nohlsearch<CR>", "Remove active search highlight" },
  ["<S-Tab>"] = { "<C-d>", "De-tab", mode = "i" },

  ["<leader>c"] = {
    name = "common-op",

    t = { "<cmd>TodoTrouble<CR>", "Open all TODOs in project" },
    s = { "<cmd>setlocal spell!<CR>", "Toggle spellcheck" },
    l = { "<cmd>setlocal number!<CR>", "Toggle line number" },
    r = { "<cmd>setlocal relativenumber!<CR>", "Toggle relative line number" },
  },
}
