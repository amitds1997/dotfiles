local package = require("core.lazy").package

package({
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = require("modules.configs.tool.nvim-tree"),
  keys = { "<Leader>e" },
})

package({
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  config = require("modules.configs.ui.catppuccin"),
  priority = 1000,
})

package({
  "stevearc/dressing.nvim",
  event = "VeryLazy",
})

package({
  "noib3/nvim-cokeline",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = require("modules.configs.ui.nvim-cokeline"),
  event = { "BufReadPre", "BufAdd", "BufNewFile" },
})

package({
  "mvllow/modes.nvim",
  event = "ModeChanged",
})

package({
  "nvim-lualine/lualine.nvim",
  config = require("modules.configs.ui.lualine"),
  event = "VeryLazy",
})

package({
  "lewis6991/gitsigns.nvim",
  config = require("modules.configs.ui.gitsigns"),
  event = { "BufRead", "BufNewFile" },
})

package({
  "folke/noice.nvim",
  event = "VeryLazy",
  config = require("modules.configs.ui.noice"),
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  }
})
