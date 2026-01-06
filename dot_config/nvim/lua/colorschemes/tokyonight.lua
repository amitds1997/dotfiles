local function tokyonight_setup()
  local transparent_background = require("settings").colorscheme.transparent_background

  ---@diagnostic disable-next-line: missing-fields
  require("tokyonight").setup {
    style = "night",
    light_style = "day",
    transparent = transparent_background,
  }

  vim.cmd.colorscheme "tokyonight"
end

return {
  "folke/tokyonight.nvim",
  name = "tokyonight",
  lazy = require("settings").colorscheme.name ~= "tokyonight",
  priority = 1000,
  config = tokyonight_setup,
}
