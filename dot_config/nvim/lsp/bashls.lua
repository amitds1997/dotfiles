---@type vim.lsp.Config
return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "bash", "sh", "zsh" },
  settings = {
    bashIde = { shellcheckArguments = "--shell=bash" },
  },
}
