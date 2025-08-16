local function catppuccin_setup()
  local transparent_background = require("settings").colorscheme.transparent_background

  require("catppuccin").setup {
    transparent_background = transparent_background,
    float = {
      transparent = true,
      solid = true,
    },
    integrations = {
      blink_cmp = {
        style = "bordered",
      },
    },
    custom_highlights = function(colors)
      return {
        CursorLineNr = { link = "CursorLine" },
        CursorLineSign = { link = "CursorLine" },
        BlinkCmpMenu = { bg = colors.base },
        BlinkCmpMenuBorder = { bg = colors.base },
        BlinkCmpDoc = { bg = colors.base },
        BlinkCmpDocBorder = { bg = colors.base },
      }
    end,
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
