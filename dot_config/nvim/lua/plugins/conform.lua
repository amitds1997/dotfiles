local function conform_setup()
  local pkg_list = { "stylua", "isort", "black" }

  for _, pkg in ipairs(pkg_list) do
    require("custom.mason_installer"):install(pkg)
  end

  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
    },
    format_after_save = {
      lsp_fallback = true,
    },
  })
end

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = conform_setup,
  cmd = "ConformInfo",
  dependencies = {
    "williamboman/mason.nvim",
  },
}
