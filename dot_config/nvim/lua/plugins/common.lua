local function load_nested(dir)
  local path = require("core.utils").path_join(vim.fn.stdpath("config"), "lua", "plugins", dir)
  assert(type(path) == "string", "Config path should be a string")

  return require("core.utils").get_plugins(path)
end

return {
  {
    "tpope/vim-sleuth",
    event = "InsertEnter",
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble" },
    config = true,
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 100
    end,
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
    keys = { { "gx", "<cmd>Browse<CR>", mode = { "n", "x" } } },
    config = true,
  },
  {
    "karb94/neoscroll.nvim",
    event = "BufReadPost",
    opts = {
      respect_scrolloff = true,
    },
  },
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "BufReadPost",
    opts = true,
  },
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
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
    lazy = true,
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
    event = "BufReadPost",
  },
  load_nested("debugger"),
  load_nested("colorschemes"),
}
