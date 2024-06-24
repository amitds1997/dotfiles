return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = require("core.vars").colorscheme ~= "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      transparent_background = require("core.vars").transparent_background,
      kitty = true,
      term_colors = true,
      integrations = {
        mason = true,
        semantic_tokens = true,
        treesitter = true,
        treesitter_context = true,
        nvimtree = true,
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        cmp = true,
        gitsigns = true,
        noice = true,
        diffview = true,
        notify = true,
        ufo = true,
        mini = {
          enabled = true,
          indentscope_color = "lavender",
        },
        fidget = true,
        neotest = true,
        neogit = true,
        dap = true,
        dap_ui = true,
        which_key = true,
        illuminate = {
          enabled = true,
          lsp = false,
        },
        lsp_saga = true,
      },
    })
    vim.cmd([[colorscheme catppuccin]])
  end,
}
