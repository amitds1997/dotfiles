return {
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
      icons = {
        group = "",
      },
    },
  },
  {
    "nvimdev/hlsearch.nvim",
    event = "BufRead",
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
        filetypes_denylist = require("core.vars").ignore_buftypes,
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
      -- Define mappings: nvim-nonicons name => nvim-web-devicons name
      local icon_mappings = {
        python = { "ipynb", "py", "pyd", "pyi", "pyo", "pyx", "py.typed" },
        lua = { "lua" },
        markdown = { "rmd" },
      }

      local icon_map = {}
      for icon_name, file_type_lst in pairs(icon_mappings) do
        for _, filetype in ipairs(file_type_lst) do
          icon_map[filetype] = icon_name
        end
      end

      local all_icons = require("nvim-web-devicons").get_icons()
      local nonicons = require("nvim-nonicons.mapping")

      local user_icons = {}
      for key, val in pairs(all_icons) do
        if nonicons[key] ~= nil or icon_map[key] ~= nil then
          user_icons[key] = val
          user_icons[key]["icon"] = require("nvim-nonicons").get(icon_map[key] or key)
        end
      end

      require("nvim-web-devicons").setup({
        override = user_icons,
      })
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPost",
    config = function()
      require("colorizer").setup({
        "*",
        "!notify",
      })
    end,
  },
  {
    "nmac427/guess-indent.nvim",
    event = "BufReadPost",
    opts = {
      buftype_exclude = require("core.vars").ignore_buftypes,
    },
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    version = "*",
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
}
