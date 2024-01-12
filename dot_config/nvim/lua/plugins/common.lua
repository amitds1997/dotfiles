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
    "nvim-tree/nvim-web-devicons",
    dependencies = {
      "yamatsum/nvim-nonicons",
    },
    config = function()
      local all_icons = require("nvim-web-devicons").get_icons()
      local nonicons = require("nvim-nonicons.mapping")

      local user_icons = {}
      for key, val in pairs(all_icons) do
        if nonicons[key] ~= nil then
          user_icons[key] = val
          user_icons[key]["icon"] = require("nvim-nonicons").get(key)
        end
      end

      require("nvim-web-devicons").setup({
        override = user_icons,
      })
    end,
  },
  {
    "ibhagwan/smartyank.nvim",
  },
}
