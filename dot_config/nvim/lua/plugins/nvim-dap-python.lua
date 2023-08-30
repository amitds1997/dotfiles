local utils = require("core.utils")

local function dap_python_setup()
  local debugpy_install_path = require("custom.mason_installer"):install("debugpy")
  local debugpy_python_path = utils.path_join(debugpy_install_path, "venv", "bin", "python")
  require("dap-python").setup(debugpy_python_path)
end

return {
  "mfussenegger/nvim-dap-python",
  event = "BufEnter *.py",
  dependencies = {
    "mfussenegger/nvim-dap",
    "williamboman/mason.nvim",
  },
  config = dap_python_setup,
}
