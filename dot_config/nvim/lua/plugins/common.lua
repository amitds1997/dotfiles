local meta_file_types = require("settings").meta_filetypes
local color_highlight_fts = { "cfg", "lua", "css", "scss", "conf" }

return {
  {
    -- Removes search highlights once we move away from it
    "nvimdev/hlsearch.nvim",
    event = "BufRead",
    config = true,
  },
  {
    -- Highlight matching paranthesis
    "utilyre/sentiment.nvim",
    version = "*",
    event = "BufReadPost",
    config = true,
  },
  {
    -- Highlight word under cursor semantically
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    config = function()
      require("illuminate").configure {
        providers = {
          "lsp",
          "treesitter",
        },
        filetypes_denylist = meta_file_types,
      }
    end,
  },
  {
    -- Guess and set correct indent levels based on file
    "nmac427/guess-indent.nvim",
    event = "BufReadPost",
    opts = {
      buftype_exclude = meta_file_types,
    },
  },
  {
    -- Show marks visually and improve functionalities
    "chentoast/marks.nvim",
    event = "BufReadPost",
    config = true,
  },
  {
    "uga-rosa/ccc.nvim",
    ft = color_highlight_fts,
    cmd = "CccPick",
    opts = function()
      local ccc = require "ccc"

      ccc.output.hex.setup { uppercase = true }
      ccc.output.hex_short.setup { uppercase = true }

      return {
        highlighter = {
          auto_enable = true,
          filetypes = color_highlight_fts,
          lsp = false,
        },
      }
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
      local nonicons = require "nvim-nonicons.mapping"

      local user_icons = {}
      for key, val in pairs(all_icons) do
        if nonicons[key] ~= nil or icon_map[key] ~= nil then
          user_icons[key] = val
          user_icons[key]["icon"] = require("nvim-nonicons").get(icon_map[key] or key)
        end
      end

      require("nvim-web-devicons").setup {
        override = user_icons,
      }
    end,
  },
  { "folke/which-key.nvim", opts = { win = { border = "rounded", wo = { winblend = 3 } } } },
  {
    -- Kitty scrollback
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = {
      "KittyScrollbackGenerateKittens",
      "KittyScrollbackCheckHealth",
      "KittyScrollbackGenerateCommandLineEditing",
    },
    event = { "User KittyScrollbackLaunch" },
    version = "*",
    config = function()
      require("kitty-scrollback").setup()
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
      signcolumn = true,
      numhl = true,
    },
  },
}
