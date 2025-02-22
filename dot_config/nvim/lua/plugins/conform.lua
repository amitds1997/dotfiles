local WORK_DIR = vim.fn.expand "~/work/"

--- Handle disabling formatting based on autoformat flag and file path
---@param bufnr number Buffer number to format
---@param default_opts conform.FormatOpts Default formatting options
---@return conform.FormatOpts|nil Format options to format with
local function handle_save_formatting(bufnr, default_opts)
  local file_path = vim.api.nvim_buf_get_name(bufnr)

  -- Work uses it's own formatting standard, let's not mess with that
  if file_path ~= "" and file_path:find("^" .. WORK_DIR) then
    return nil
  end

  return default_opts
end

local function conform_config()
  local js_formatter = { "prettierd", "prettier", stop_after_first = true }

  require("conform").setup {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_fix", "isort", "black" },
      markdown = { "mdformat" },
      sql = { "sql_formatter" },
      yaml = { "yamlfix" },
      go = { "goimports", "gofumpt" },
      sh = { "shfmt" },
      css = js_formatter,
      scss = js_formatter,
      javascript = js_formatter,
      typescript = js_formatter,
    },
    format_after_save = function(bufnr)
      return handle_save_formatting(bufnr, {
        lsp_fallback = true,
      })
    end,
    formatters = {
      mdformat = {
        prepend_args = { "--number" },
      },
      injected = {
        options = {
          lang_to_formatters = {
            yaml = {}, -- Do not try to format YAML (because it is also used for frontmatter)
          },
        },
      },
      yamlfix = {
        env = {
          YAMLFIX_preserve_quotes = "TRUE",
          YAMLFIX_WHITELINES = "1",
          YAMLFIX_SECTION_WHITELINES = "1",
          YAMLFIX_SEQUENCE_STYLE = "keep_style",
        },
      },
    },
  }
end

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = conform_config,
  cmd = "ConformInfo",
  dependencies = {
    "williamboman/mason.nvim",
  },
}
