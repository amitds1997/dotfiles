return {
  -- Move b/w windows
  ["<C-h>"] = { "<cmd>wincmd h<CR>", "Move to window on left" },
  ["<C-k>"] = { "<cmd>wincmd k<CR>", "Move to window on top" },
  ["<C-l>"] = { "<cmd>wincmd l<CR>", "Move to window on right" },
  ["<C-j>"] = { "<Cmd>wincmd j<CR>", "Move to window on bottom" },

  -- Adjust window size
  ["<C-,>"] = { "<cmd>wincmd ><CR>", "Increase window size towards left" },
  ["<C-.>"] = { "<cmd>wincmd <<CR>", "Increase window size towards right" },
  ["+"] = { "<cmd>wincmd +<CR>", "Increase window size towards top" },
  ["-"] = { "<cmd>wincmd -<CR>", "Increase window size towards bottom" },
  ["="] = { "<cmd>wincmd =<CR>", "Restore default window size" },

  ["<leader>w"] = {
    name = "window",

    q = { "<cmd>close<CR>", "Close window" },
    o = { "<cmd>only<CR>", "Close every other window except current" },
    e = {
      function()
        require("oil").toggle_float()
      end,
      "Open directory explorer",
    },
  },
}
