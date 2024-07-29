local function install_mdformat_extra_packages()
  local mdformat = require("mason-registry").get_package("mdformat")
  mdformat:on("install:success", function()
    local pip_path = vim.fs.joinpath(mdformat:get_install_path(), "venv", "bin", "pip")
    local args = { "install", "mdformat-gfm", "mdformat-frontmatter", "mdformat-footnote" }

    require("plenary.job")
      :new({
        command = pip_path,
        args = args,
        on_start = function()
          vim.notify("Installing mdformat dependencies")
        end,
        on_exit = function(_, return_val)
          if return_val == 0 then
            vim.notify("mdformat dependencies installed successfully")
          end
        end,
      })
      :start()
  end)
end

local function conform_setup()
  -- Special handling for mdformat
  install_mdformat_extra_packages()

  ---@param default conform.FormatOpts
  ---@return conform.FormatOpts
  local function handle_disabling_formatting(bufnr, default)
    -- Check if formatting has been disabled on the buffer
    if vim.b[bufnr].disable_autoformat then
      ---@diagnostic disable-next-line: missing-return-value
      return
    end
    return default
  end

  local js_formatter = { "prettierd", "prettier", stop_after_first = true }
  require("conform").setup({
    log_level = vim.log.levels.DEBUG,
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
      return handle_disabling_formatting(bufnr, {
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
        },
      },
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
    "nvim-lua/plenary.nvim",
  },
}
