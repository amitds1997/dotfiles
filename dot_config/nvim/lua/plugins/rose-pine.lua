local function rose_pine_config()
  local p = require("rose-pine.palette")
  local is_transparent = require("core.vars").transparent_background
  local telescope_bg_color = is_transparent and p.none or p.overlay
  local telescope_fg_color = is_transparent and p.none or p.rose
  local telescope_prompt_color = is_transparent and p.none or p.overlay

  require("rose-pine").setup({
    disable_background = is_transparent,
    disable_float_background = is_transparent,
    dark_variant = "moon",
    highlight_groups = {
      IlluminatedWordText = { bg = p.highlight_med },
      IlluminatedWordRead = { bg = p.highlight_med },
      IlluminatedWordWrite = { bg = p.highlight_med },
      TelescopeNormal = { bg = telescope_bg_color, fg = telescope_fg_color },
      TelescopeBorder = { bg = telescope_bg_color, fg = telescope_bg_color },
      TelescopePromptNormal = { bg = telescope_prompt_color },
      TelescopePromptBorder = { bg = telescope_prompt_color, fg = telescope_prompt_color },
      TelescopePromptTitle = { bg = telescope_fg_color, fg = telescope_bg_color },
      TelescopePreviewTitle = { bg = telescope_fg_color, fg = telescope_bg_color },
      TelescopeResultsTitle = { bg = telescope_fg_color, fg = telescope_bg_color },
    },
  })
end

return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  config = rose_pine_config,
  lazy = false,
}
