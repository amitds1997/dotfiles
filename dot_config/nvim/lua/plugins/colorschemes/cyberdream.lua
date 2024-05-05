return {
  "scottmckendry/cyberdream.nvim",
  lazy = require("core.vars").colorscheme ~= "cyberdream",
  priority = 1000,
  config = function()
    require("cyberdream").setup({
      transparent = true,
      italic_comments = true,
      hide_fillchars = true,
      borderless_telescope = false,
      terminal_colors = true,
    })
    vim.cmd([[colorscheme cyberdream]])
  end,
}
