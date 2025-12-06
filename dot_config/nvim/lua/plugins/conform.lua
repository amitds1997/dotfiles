local WORK_DIR = vim.fn.expand "~/work/"

-- By default, autoformatting is on
vim.g.autoformat = vim.g.autoformat ~= false

---@module 'lazy'
---@type LazyPluginSpec[]
return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        dbt = { "sqlfmt" },
        go = { "goimports", "gofumpt" },
        json = { "prettier", timeout_ms = 500, lsp_format = "fallback" },
        jsonc = { "prettier", timeout_ms = 500, lsp_format = "fallback" },
        lua = { "stylua" },
        dockerfile = { "dockerfmt", lsp_format = "fallback" },
        markdown = { "prettier" },
        python = { "black", "isort", "ruff_fix", "ruff_format" },
        sh = { "shfmt" },
        sql = { "sqruff" },
        yaml = { "prettier" },
        rust = { name = "rust_analyzer", timeout_ms = 500, lsp_format = "prefer" },
        toml = { "tombi" },
        ["_"] = { "trim_whitespace", "trim_newlines" },
      },
      formatters = {
        injected = {
          lang_to_ft = {
            bash = "sh",
          },
          lang_to_ext = {
            bash = "sh",
            c_sharp = "cs",
            elixir = "exs",
            javascript = "js",
            julia = "jl",
            latex = "tex",
            markdown = "md",
            python = "py",
            ruby = "rb",
            rust = "rs",
            teal = "tl",
            typescript = "ts",
          },
        },
        prettier = {
          prepend_args = { "--trailing-comma", "none", "--prose-wrap", "always" },
        },
        tombi = {
          append_args = { "--offline" },
        },
      },
      format_on_save = function(bufnr)
        _ = bufnr

        if vim.g.minifiles_active then
          return nil
        end

        -- If it is not defined, set it to `True`
        vim.g.autoformat = vim.g.autoformat ~= false
        if not vim.g.autoformat then
          return nil
        end

        -- Do not format work files; rest are up for game
        -- local file_path = vim.api.nvim_buf_get_name(bufnr)
        -- if file_path ~= "" and file_path:find("^" .. WORK_DIR) then
        --   return nil
        -- end

        return {}
      end,
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.g.autoformat = true
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        "ruff",
        "rust-analyzer",
        "stylua",
        "sqlfmt",
        "shfmt",
        "sqruff",
        "gofumpt",
        "goimports",
      },
    },
  },
}
