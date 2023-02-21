return function ()
  require("catppuccin").setup({
    flavour = "mocha",
    background = { light = "latte", dark = "mocha" },
    transparent_background = false,
    term_colors = true,
    integrations = {
      mason = true,
      semantic_tokens = true,
      treesitter = true,
      nvimtree = true,
      telescope = true,
      cmp = true,
      gitsigns = true,
      noice = true,
      notify = true,
      dap = {
        enabled = true,
        enabled_ui = true,
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
      },
      lsp_trouble = true,
    },
  })

  vim.cmd.colorscheme("catppuccin")
end
