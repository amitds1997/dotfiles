return {
  -- Move b/w windows
  ["<C-h>"] = { "<C-W>h", "Move to window on left" },
  ["<C-k>"] = { "<C-W>k", "Move to window on top" },
  ["<C-l>"] = { "<C-W>l", "Move to window on right" },
  ["<C-j>"] = { "<C-W>j", "Move to window on bottom" },

  -- Adjust window size
  ["<C-,>"] = { "<C-w>>", "Increase window size towards left" },
  ["<C-.>"] = { "<C-w><", "Increase window size towards right" },
  ["+"] = { "<C-w>+", "Increase window size towards top" },
  ["-"] = { "<C-w>-", "Increase window size towards bottom" },
  ["="] = { "<C-w>=", "Restore default window size" },

  ["<leader>w"] = {
    name = "+window",

    q = { "<cmd>close<CR>", "Close window" },
    o = { "<cmd>only<CR>", "Close every other window except current" },
  },
}
