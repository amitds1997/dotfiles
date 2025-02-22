local function rose_pine_setup()
  local transparent_background = require("settings").colorscheme.transparent_background

  require("rose-pine").setup {
    dim_inactive_windows = not transparent_background,
    styles = {
      transparency = transparent_background,
    },
  }
  vim.cmd.colorscheme "rose-pine"
end

return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  config = rose_pine_setup,
  lazy = require("settings").colorscheme.name ~= "rose-pine",
}
