return {
  {
    "tpope/vim-sleuth",
    event = "InsertEnter",
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble" },
    config = true,
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "folke/which-key.nvim",
    opts = {
      window = {
        border = "rounded",
      },
    }
  },
}
