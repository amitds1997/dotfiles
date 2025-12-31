---@type vim.lsp.Config
return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = {
    -- "python",
  },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      disableTaggedHints = false,
      analysis = {
        typeCheckingMode = "standard",
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        diagnosticSeverityOverrides = {
          reportIgnoreCommentWithoutRule = true,
        },
      },
    },
  },
}
