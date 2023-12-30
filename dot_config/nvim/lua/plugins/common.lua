return {
  {
    "tpope/vim-sleuth",
    event = "InsertEnter",
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble" },
    config = true,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "folke/which-key.nvim",
    opts = {
      window = {
        border = "rounded",
      },
    },
  },
  {
    "nvimdev/hlsearch.nvim",
    event = "BufRead",
    config = true,
  },
  {
    "chrishrb/gx.nvim",
    event = "BufEnter",
    config = true,
  },
  {
    "karb94/neoscroll.nvim",
    event = "BufEnter",
    opts = {
      respect_scrolloff = true,
    },
  },
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "RRethy/vim-illuminate",
    event = "BufEnter",
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
        },
        filetypes_denylist = {
          "checkhealth",
          "help",
          "lspinfo",
          "man",
          "nofile",
          "notify",
          "query",
          "prompt",
          "qf",
          "terminal",
          "gitcommit",
          "gitrebase",
          "svn",
          "hgcommit",
          "TelescopePrompt",
        },
      })
    end,
  },
  {
    "yamatsum/nvim-nonicons",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
    config = true,
  },
}
