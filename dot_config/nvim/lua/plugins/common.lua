local meta_file_types = require("settings").meta_filetypes

---@module 'lazy'
---@type LazyPluginSpec[]
return {
  {
    -- Guess and set correct indent levels based on file
    "nmac427/guess-indent.nvim",
    event = "BufReadPost",
    opts = {
      buftype_exclude = meta_file_types,
    },
  },
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
    "nvim-tree/nvim-web-devicons",
    dependencies = { { "mskelton/termicons.nvim", build = false } },
    config = function()
      require("termicons").setup()
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        winblend = 0,
        should_preview_cb = function(bufnr, _)
          if vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == "bigfile" then
            return false
          end

          return true
        end,
      },
    },
  },
}
