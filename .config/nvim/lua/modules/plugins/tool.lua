local package = require("core.pack").package

package({
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = require("modules.configs.tool.telescope"),
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        lazy = true,
      },
    },
    keys = { "<Leader>ff", "<Leader>fw", "<Leader>fg" },
  },
})

package({
  "folke/trouble.nvim",
  lazy = true,
  keys = {
    { "<leader>xx", "<cmd>TroubleToggle<cr>" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<cr>" }
  }
})

package({

})
