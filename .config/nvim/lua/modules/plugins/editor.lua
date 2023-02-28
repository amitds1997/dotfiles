local package = require("core.lazy").package

package({
  "numToStr/Comment.nvim",
  config = require("modules.configs.editor.comment"),
  event = "BufReadPost",
})

package({
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = require("modules.configs.editor.treesitter"),
  -- event = { "BufRead", "CmdlineEnter" },
  event = "VeryLazy"
})

package({
  "norcalli/nvim-colorizer.lua",
  event = "BufReadPre",
  config = require("modules.configs.editor.colorizer"),
})

package({
  "ojroques/nvim-bufdel",
  event = "BufReadPost",
})

package({
  "romainl/vim-cool",
  event = "VeryLazy",
})
