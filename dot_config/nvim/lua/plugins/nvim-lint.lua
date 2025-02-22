local function run_lint()
  -- Use nvim-lint's logic first:
  -- * checks if linters exist for the full filetype first
  -- * otherwise will split filetype by "." and add all those linters
  -- * this differs from conform.nvim which only uses the first filetype that has a formatter
  local lint = require "lint"
  local names = lint._resolve_linter_by_ft(vim.bo.filetype)

  -- Add fallback linters.
  if #names == 0 then
    vim.list_extend(names, lint.linters_by_ft["_"] or {})
  end

  -- Add global linters.
  vim.list_extend(names, lint.linters_by_ft["*"] or {})

  -- Filter out linters that don't exist or don't match the condition.
  local ctx = { filename = vim.api.nvim_buf_get_name(0) }
  ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
  names = vim.tbl_filter(function(name)
    local linter = lint.linters[name]
    if not linter then
      vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
    end
    ---@diagnostic disable-next-line: undefined-field
    return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
  end, names)

  -- Run linters.
  if #names > 0 then
    lint.try_lint(names)
  end
end

local function nvim_lint_setup(_, opts)
  local lint = require "lint"
  lint.linters_by_ft = opts.linters_by_ft
  local U = require "utils"

  vim.api.nvim_create_autocmd(opts.events, {
    group = U.create_augroup "nvim-lint",
    callback = U.debounce(100, run_lint),
  })
end

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePost" },
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      lua = { "selene" },
      python = { "vulture" },
      markdown = { "markdownlint" },
      sh = { "shellcheck" },
      dockerfile = { "hadolint" },
      json = { "jsonlint" },
      go = { "golangcilint" },
      sql = { "sqlfluff" },
      yaml = { "yamllint" },
      css = { "stylelint" },
    },
  },
  config = nvim_lint_setup,
}
