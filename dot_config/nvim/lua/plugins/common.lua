return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 100
    end,
    opts = {
      win = {
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
  { -- mini.animate has some weird kinks for my preferences, so not using it
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
        filetypes_denylist = require("core.vars").temp_buf_filetypes,
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
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    config = function()
      local filetypes = vim.tbl_map(
        function(ft)
          return ("!%s"):format(ft)
        end,
        vim.tbl_filter(function(ft)
          return not vim.list_contains({ "help" }, ft)
        end, require("core.vars").temp_buf_filetypes)
      )
      table.insert(filetypes, 1, "*")
      require("colorizer").setup({
        filetypes = filetypes,
        user_default_options = {
          tailwind = true,
        },
      })
    end,
  },
  {
    "nmac427/guess-indent.nvim",
    event = "BufReadPost",
    opts = {
      buftype_exclude = require("core.vars").temp_buf_filetypes,
    },
  },
  {
    "sindrets/diffview.nvim",
    event = "CmdlineEnter",
  },
  {
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
  {
    "chentoast/marks.nvim",
    event = "BufReadPost",
    config = true,
  },
}
