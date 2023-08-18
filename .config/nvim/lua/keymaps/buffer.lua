return {
  ["<TAB>"] = { ":bnext<CR>", "Go to next buffer" },
  ["<S-TAB>"] = { ":bprev<CR>", "Go to previous buffer" },

  ["<leader>f"] = {
    name = "buffer",

    d = { "<cmd>bd<CR>", "Delete buffer" }
  }
}
