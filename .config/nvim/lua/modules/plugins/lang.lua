local package = require("core.pack").package

package({
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    config = require("modules.configs.lang.lsp-setup"),
    event = { "BufNewFile", "BufReadPre", "BufAdd" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
          ui = { border = "rounded" }
        }
      },
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "folke/neodev.nvim",
      -- "jay-babu/mason-nvim-dap.nvim",
    }
  }
})

--[[ package({
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  enabled = false,
}) ]]
package({
  "mfussenegger/nvim-dap",
  lazy = true,
  cmd = {
    "DapSetLogLevel",
    "DapShowLog",
    "DapContinue",
    "DapToggleBreakpoint",
    "DapToggleRepl",
    "DapStepOver",
    "DapStepInto",
    "DapStepOut",
    "DapTerminate",
  },
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      config = require("modules.configs.lang.nvim-dap-ui"),
    },
    {
      "jbyuki/one-small-step-for-vimkind",
      config = require("modules.configs.lang.dap-adapters.lua"),
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      config = require("modules.configs.lang.nvim-dap-virtual-text")
    }
  },
  config = require("modules.configs.lang.nvim-dap"),
  keys = { "<Leader>db", "<Leader>dc", "<Leader>du", "<Leader>dld" }
})

package({
  "jose-elias-alvarez/null-ls.nvim",
  event = "VeryLazy",
  config = require("modules.configs.lang.null-ls"),
  dependencies = {
    "nvim-lua/plenary.nvim"
  }
})
