local function conform_setup()
  local pkg_list = { "stylua", "isort", "black", "sqlfmt", "mdformat" }

  for _, pkg in ipairs(pkg_list) do
    require("custom.mason_installer"):install(pkg)
  end

  local function handle_disabling_formatting(bufnr, default)
    -- Check if formatting has been disabled on the buffer
    if vim.b[bufnr].disable_autoformat then
      return
    end
    return default
  end

  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      markdown = { "mdformat", "injected" },
      sql = { "sqlfmt" },
    },
    format_after_save = function(bufnr)
      return handle_disabling_formatting(bufnr, {
        lsp_fallback = true,
      })
    end,
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
