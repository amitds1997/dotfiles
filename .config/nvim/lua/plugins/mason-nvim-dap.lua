local utils = require("core.utils")

return {
  "jay-babu/mason-nvim-dap.nvim",
  event = "LspAttach",
  dependencies = {
    "mfussenegger/nvim-dap",
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap-python",
  },
  opts = {
    ensure_installed = { "python" },
    automatic_installation = true,
    handlers = {
      function (config)
        require("mason-nvim-dap").default_setup(config)
      end,
      python = function (config)
        require("dap-python").setup(utils.path_join(vim.fn.exepath("debugpy"), "venv", "bin", "python"))
        require("mason-nvim-dap").default_setup(config)
      end
    },
  }
}
