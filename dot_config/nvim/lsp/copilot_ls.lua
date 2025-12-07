---@type vim.lsp.Config
return {
  name = "copilot_ls",
  cmd = { "copilot-language-server", "--stdio" },
  root_markers = { ".git" },
  init_options = {
    editorInfo = {
      name = "Neovim",
      version = tostring(vim.version()),
    },
    editorPluginInfo = {
      name = "Neovim",
      version = tostring(vim.version()),
    },
  },
  settings = {
    telemetry = {
      telemetryLevel = "off",
    },
    nextEditSuggestions = {
      enabled = true,
    },
  },
}
