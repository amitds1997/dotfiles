local catppuccin_config = function ()
  require("catppuccin").setup({
    flavour = "mocha",
    background = { light = "latte", dark = "mocha" },
    transparent_background = true,
    term_colors = true,
    integrations = {
      mason = true,
      semantic_tokens = true,
      treesitter = true,
      nvimtree = true,
      telescope = {
        enabled = true
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
      navic = {
        enabled = true,
        custom_bg = "NONE",
      },
      lsp_trouble = true,
      which_key = true,
    },
  })

  vim.cmd.colorscheme("catppuccin")
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  config = catppuccin_config,
  priority = 1000,
}
