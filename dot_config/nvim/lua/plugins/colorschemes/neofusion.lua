local function neofusion_config()
  local is_transparent = require("core.vars").transparent_background
  require("neofusion").setup({
    transparent_mode = is_transparent,
  })
  vim.cmd([[ colorscheme neofusion ]])
end

return {
  "diegoulloao/neofusion.nvim",
  lazy = require("core.vars").colorscheme ~= "neofusion",
  priority = 1000,
  config = neofusion_config,
}
