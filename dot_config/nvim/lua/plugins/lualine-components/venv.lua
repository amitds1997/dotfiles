local M = {
  venv = "",
}

function M.current_venv()
  if vim.bo.filetype == "python" then
    return M.venv
  end
  return ""
end

vim.api.nvim_create_autocmd({ "LspAttach", "BufEnter" }, {
  pattern = "*.py",
  callback = function()
    -- Returns correct virtual environment (for Python)
    if vim.bo.filetype == "python" then
      ---@diagnostic disable-next-line: undefined-field
      local venv_name = (vim.uv.os_getenv("CONDA_DEFAULT_ENV") or vim.uv.os_getenv("VIRTUAL_ENV") or "")
      local python_version = vim.fn.has("nvim-0.10") == 1
          and vim
            .system({ "python", "--version" }, {
              timeout = 200,
            })
            :wait().stdout
        or vim.fn.system("python --version")

      if venv_name and venv_name ~= "" then
        M.venv = venv_name .. " (" .. vim.trim(python_version) .. ")"
      else
        M.venv = vim.trim(python_version)
      end
    end
  end,
})

return M
