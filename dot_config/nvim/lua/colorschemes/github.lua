return {
  "projekt0n/github-nvim-theme",
  name = "github-theme",
  priority = 1000,
  lazy = require("settings").colorscheme.name ~= "github-theme",
  config = function()
    local transparent_background = require("settings").colorscheme.transparent_background

    require("github-theme").setup {
      options = {
        transparent = transparent_background,
        styles = {
          comments = "italic",
        },
        darken = {},
      },
    }

    vim.cmd.colorscheme "github_dark_dimmed"
  end,
}
