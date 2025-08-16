local function run_lint()
  -- We want to apply all linters on a file
  -- 1. Apply applicable filetype linters on the file
  -- 2. If there are any universal linters, try those too
  local lint = require "lint"
  local filetype_linters = lint._resolve_linter_by_ft(vim.bo.filetype)

  local applicable_linters = vim.list_extend({}, filetype_linters)

  -- If no linter is available, the negative linters are applicable if available
  if #applicable_linters == 0 then
    vim.list_extend(applicable_linters, lint.linters_by_ft["_"] or {})
  end

  -- Add universal linters into applicable_linters
  vim.list_extend(applicable_linters, lint.linters_by_ft["*"] or {})

  if #applicable_linters > 0 then
    lint.try_lint(applicable_linters)
  end
end

---@module 'lazy'
---@type LazyPluginSpec[]
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        css = { "stylelint" },
        dockerfile = { "hadolint" },
        go = { "golangcilint" },
        make = { "checkmake" },
        json = { "jsonlint" },
        lua = { "selene" },
        markdown = { "markdownlint" },
        python = { "bandit", "vulture" },
        sh = { "shellcheck" },
        sql = { "sqlfluff" },
        yaml = { "yamllint", "yq" },
        envfile = { "dotenv_linter" },
        ["yaml.ghaction"] = { "actionlint" },
      },
    },
    config = function(_, opts)
      local lint = require "lint"

      lint.linters_by_ft = opts.linters_by_ft
      local U = require "core.utils"

      vim.api.nvim_create_autocmd(opts.events, {
        group = U.create_augroup "linter",
        desc = "Run linter on the buffer",
        callback = U.debounce(100, run_lint),
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "dotenv-linter",
        "bandit",
        "actionlint",
        "golangci-lint",
        -- "hadolint", -- FIX: Until this is fixed: https://github.com/mason-org/mason.nvim/issues/1865
        "jsonlint",
        "markdownlint",
        "selene",
        "shellcheck",
        "sqlfluff",
        "stylelint",
        "vulture",
        "yamllint",
        "yq",
        "checkmake",
      },
    },
  },
}
