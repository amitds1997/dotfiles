local function kanagawa_config()
  local is_transparent = require("core.vars").transparent_background
  require("kanagawa").setup({
    transparent = is_transparent,
    background = {
      dark = "dragon",
      light = "lotus",
    },
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = "none",
          },
        },
      },
    },
    overrides = function(colors)
      local theme = colors.theme
      local telescope_color = is_transparent and "none" or theme.ui.bg_dim
      local telescope_border_hl = { bg = telescope_color, fg = telescope_color }
      return {
        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        FloatTitle = { bg = "none" },

        -- Save an hlgroup with dark background and dimmed foreground
        -- so that you can use it where your still want darker windows.
        -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

        -- Popular plugins that open floats will link to NormalFloat by default;
        -- set their background accordingly if you wish to keep them dark and borderless
        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        TelescopeBorder = telescope_border_hl,
        TelescopePromptBorder = telescope_border_hl,
        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },
      }
    end,
  })
  vim.cmd.colorscheme("kanagawa")
end

return {
  "rebelot/kanagawa.nvim",
  lazy = require("core.vars").colorscheme ~= "kanagawa",
  priority = 1000,
  config = kanagawa_config,
}
