local M = {
  venv = "",
  python_version = "",
}

function M.current_env()
  local label = ""
  if M.venv ~= "" then
    label = label .. " | " .. M.venv
  end

  if M.python_version ~= "" then
    label = label .. " | " .. M.python_version
  end

  return label
end

vim.api.nvim_create_autocmd({ "LspAttach" }, {
  pattern = "*.py",
  callback = function()
    if vim.bo.filetype == "python" then
      vim.system({ "python", "--version" }, { text = true }, function(obj)
        M.python_version = vim.trim(obj.stdout)
      end)

      ---@diagnostic disable-next-line: undefined-field
      local venv_name = (vim.uv.os_getenv("CONDA_DEFAULT_ENV") or vim.uv.os_getenv("VIRTUAL_ENV") or "")
      M.venv = (venv_name and venv_name ~= "") and venv_name or ""
    end
  end,
})

return M
