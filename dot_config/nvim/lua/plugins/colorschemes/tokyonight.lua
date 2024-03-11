local function tokyonight_config()
  local is_transparent = require("core.vars").transparent_background

  require("tokyonight").setup({
    style = "night",
    light_style = "day",
    transparent = is_transparent,
    terminal_colors = true,
    styles = {
      sidebars = is_transparent and "transparent" or "dark",
      floats = is_transparent and "transparent" or "dark",
    },
    on_highlights = function(hl, c)
      if not is_transparent then
        local prompt = "#2d3149"
        hl.TelescopeNormal = {
          bg = c.bg_dark,
          fg = c.fg_dark,
        }
        hl.TelescopeBorder = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopePromptNormal = {
          bg = prompt,
        }
        hl.TelescopePromptBorder = {
          bg = prompt,
          fg = prompt,
        }
      end
      hl.TelescopePromptTitle = {
        bg = c.fg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopePreviewTitle = {
        bg = c.fg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopeResultsTitle = {
        bg = c.fg_dark,
        fg = c.bg_dark,
      }
      hl.LspInlayHint = {
        link = "Comment",
      }
    end,
  })
end

return {
  "folke/tokyonight.nvim",
  name = "tokyonight",
  lazy = require("core.vars").colorscheme ~= "tokyonight",
  priority = 1000,
  config = tokyonight_config,
}
