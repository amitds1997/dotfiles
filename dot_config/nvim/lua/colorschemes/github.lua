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
        darken = {
          floats = false,
        },
      },
      groups = {
        all = {
          CursorLineNr = { link = "CursorLine" },
          CursorLineSign = { link = "CursorLine" },
          -- TODO: Remove these once https://github.com/projekt0n/github-nvim-theme/pull/370 is merged
          BlinkCmpMenu = { fg = "fg1", bg = "bg1" },
          BlinkCmpMenuBorder = { link = "FloatBorder" },
        },
      },
    }

    vim.cmd.colorscheme "github_dark_dimmed"
  end,
}
