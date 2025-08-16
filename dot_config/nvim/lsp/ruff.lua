---@type vim.lsp.Config
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  capabilities = {
    general = {
      positionEncodings = { "utf-16" }, -- Setting this because `pyright` only supports `utf-16`. TODO: Once we migrate to `ty`, we should be able to remove this one
    },
  },
}
