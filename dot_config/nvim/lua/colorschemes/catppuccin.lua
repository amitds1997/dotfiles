local function catppuccin_setup()
  local transparent_background = require("settings").colorscheme.transparent_background

  require("catppuccin").setup {
    transparent_background = transparent_background,
  }
  vim.cmd.colorscheme "catppuccin"
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = catppuccin_setup,
  lazy = require("settings").colorscheme.name ~= "catppuccin",
}
