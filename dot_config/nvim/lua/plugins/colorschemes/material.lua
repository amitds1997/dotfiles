local function material_config()
  require("material").setup({
    styles = {
      comments = { italic = true },
    },
    disable = {
      background = require("core.vars").transparent_background,
    },
    lualine_style = "stealth",
    high_visibility = {
      darker = true,
      lighter = true,
    },
    custom_highlights = {
      TreesitterContext = { link = "Normal" },
      TreesitterContextLineNumber = { link = "LineNr" },
    },
  })
  ---@type "deep ocean"|"darker"|"lighter"|"palenight"|"oceanic"
  vim.g.material_style = "oceanic"
  vim.cmd.colorscheme("material")
end

return {
  "marko-cerovac/material.nvim",
  lazy = require("core.vars").colorscheme ~= "material",
  priority = 1000,
  config = material_config,
}
