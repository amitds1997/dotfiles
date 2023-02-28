local package = require("core.lazy").package

package({
  {
    "neovim/nvim-lspconfig",
    config = require("modules.configs.lang.lsp-setup"),
    event = { "BufNewFile", "BufReadPre", "BufAdd" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
          ui = { border = "rounded" },
        },
      },
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = require("modules.configs.lang.null-ls"),
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
      },
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
    },
  },
})

package({
  "mfussenegger/nvim-dap",
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
      config = require("modules.configs.lang.nvim-dap-virtual-text"),
    },
  },
  config = require("modules.configs.lang.nvim-dap"),
  keys = { "<Leader>db", "<Leader>dc", "<Leader>du", "<Leader>dld" },
})
