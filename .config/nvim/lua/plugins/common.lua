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
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for keymaps that start with a native binding
        i = { "j", "k" },
        v = { "j", "k" },
        n = { "<TAB>", "<S-TAB>"}
      },
    }
  },
}
