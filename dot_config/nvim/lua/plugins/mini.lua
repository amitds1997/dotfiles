return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    event = "BufReadPost",
    config = function()
      -- Extend and create a/i textobjects
      require("mini.ai").setup()
      -- Move selected block using <Alt-h/j/k/l> key
      require("mini.move").setup()
      -- Add, delete, replace, find, highlight surrounding
      require("mini.surround").setup()
    end,
  },
}
