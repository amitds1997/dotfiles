local function dap_python_setup()
  -- local debugpy_install_path = require("custom.mason_installer"):install("debugpy")
  -- local debugpy_python_path = vim.fs.joinpath(debugpy_install_path, "venv", "bin", "python")
  -- require("dap-python").setup(debugpy_python_path)
end

return {
  "mfussenegger/nvim-dap-python",
  event = "BufEnter *.py",
  config = dap_python_setup,
}
