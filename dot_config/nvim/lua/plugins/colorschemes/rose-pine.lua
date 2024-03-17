local function rose_pine_config()
  local p = require("rose-pine.palette")
  local is_transparent = require("core.vars").transparent_background
  local telescope_bg_color = is_transparent and p.none or p.overlay
  local telescope_fg_color = is_transparent and p.none or p.rose

  local title_hl = { bg = telescope_fg_color, fg = telescope_bg_color }
  local border_hl = { bg = telescope_bg_color, fg = telescope_bg_color }

  require("rose-pine").setup({
    dim_inactive_windows = not is_transparent,
    variant = "moon",
    extend_background_behind_borders = true,
    styles = {
      bold = true,
      italic = true,
      transparency = is_transparent,
    },
    dark_variant = "moon",
    highlight_groups = {
      IlluminatedWordText = { bg = p.highlight_med },
      IlluminatedWordRead = { bg = p.highlight_med },
      IlluminatedWordWrite = { bg = p.highlight_med },
      TelescopeNormal = { bg = telescope_bg_color, fg = telescope_fg_color },
      TelescopeBorder = border_hl,
      TelescopePromptNormal = { bg = telescope_bg_color },
      TelescopePromptBorder = border_hl,
      TelescopePromptTitle = title_hl,
      TelescopePreviewTitle = title_hl,
      TelescopeResultsTitle = title_hl,
      TelescopeSelection = { fg = "text", bg = "highlight_med" },
      TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
      TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },
      TelescopeTitle = { fg = "base", bg = "love" },
      LspInlayHint = { link = "Comment" },
    },
  })

  vim.cmd([[colorscheme rose-pine]])
end

return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  config = rose_pine_config,
  lazy = require("core.vars").colorscheme ~= "rose-pine",
}
