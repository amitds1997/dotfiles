local function teide_setup()
  local transparent_background = require("settings").colorscheme.transparent_background

  ---@diagnostic disable-next-line: missing-fields
  require("teide").setup {
    style = "dark",
    transparent = transparent_background,
  }

  vim.cmd.colorscheme "teide"
end
return {
  "serhez/teide.nvim",
  lazy = require("settings").colorscheme.name ~= "teide",
  priority = 1000,
  config = teide_setup,
}
