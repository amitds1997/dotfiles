local package = require("core.pack").package

package({
  "numToStr/Comment.nvim",
  lazy = true,
  config = require("modules.configs.editor.comment"),
  event = "BufWinEnter",
})

package({
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = true,
  config = require("modules.configs.editor.treesitter"),
  event = { "BufRead", "CmdlineEnter" },
  dependencies = {
    {
      "norcalli/nvim-colorizer.lua",
      config = require("modules.configs.editor.colorizer"),
    }
  }
})

package({
  "ojroques/nvim-bufdel",
  lazy = true,
  event = "BufReadPost",
})
