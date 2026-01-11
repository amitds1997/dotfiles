local transparent_background = require("settings").colorscheme.transparent_background

return {
  "webhooked/kanso.nvim",
  priority = 1000,
  lazy = require("settings").colorscheme.name ~= "kanso",
  opts = {
    undercurl = false,
    transparent = transparent_background,
    background = {
      dark = "ink",
      light = "pearl",
    },
    foreground = {
      dark = "saturated",
    },
    overrides = function()
      return {
        -- These two highlights allow the cursor to span across the sign column
        CursorLineNr = { link = "CursorLine" },
        CursorLineSign = { link = "CursorLine" },
        WinSeparator = { link = "FloatBorder" },
        ["@string.special.url"] = { undercurl = false },
        MiniIndentscopeSymbol = { link = "SnacksIndentChunk", force = true },
        DapStoppedLine = { link = "Visual" },
      }
    end,
  },
  config = function(_, opts)
    require("kanso").setup(opts)

    vim.cmd.colorscheme "kanso"
  end,
}
