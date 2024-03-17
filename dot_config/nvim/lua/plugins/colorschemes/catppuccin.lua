return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = require("core.vars").colorscheme ~= "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme catppuccin]])
  end,
  opts = {
    flavour = "mocha",
    background = { light = "latte", dark = "mocha" },
    transparent_background = require("core.vars").transparent_background,
    term_colors = true,
    integrations = {
      mason = true,
      semantic_tokens = true,
      treesitter = true,
      nvimtree = true,
      telescope = {
        enabled = true,
        style = "nvchad",
      },
      cmp = true,
      gitsigns = true,
      noice = true,
      notify = true,
      mini = true,
      dap = {
        enabled = true,
        enabled_ui = true,
      },
      which_key = true,
      illuminate = {
        enabled = true,
        lsp = false,
      },
    },
  },
}
