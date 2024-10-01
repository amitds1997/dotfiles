return {
  -- Max filesize limit for certain plugins and/or functionalities
  max_filesize = 1024 * 1024, -- 1 MiB
  ---@type "tokyonight"|"catppuccin"|"rose-pine"|"material"|"kanagawa"|"cyberdream"|"neofusion"
  colorscheme = "tokyonight",
  ---@type boolean
  transparent_background = false,
  ---@type boolean
  is_remote = vim.g.remote_neovim_host and true or false,
  oil = {
    hidden_file_patterns = {
      "^%.git$",
      "^node_modules$",
      "^%.cache$",
      "%.DS_Store",
    },
    always_hidden_patterns = {
      "^%.%.$",
    },
  },
  temp_filetypes = {
    "TelescopePrompt",
    "checkhealth",
    "gitcommit",
    "gitrebase",
    "help",
    "hgcommit",
    "lspinfo",
    "man",
    "nofile",
    "notify",
    "oil",
    "prompt",
    "qf",
    "query",
    "svn",
    "terminal",
    "sagarename",
    "sagafinder",
    "gitsigns-blame",
  },
  -- These will be auto-installed by treesitter
  ts_parsers = {
    "bash",
    "c",
    "cpp",
    "csv",
    "diff",
    "dockerfile",
    "editorconfig",
    "git_config",
    "git_rebase",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "gowork",
    "helm",
    "html",
    "hyprlang",
    "ini",
    "javascript",
    "json",
    "json5",
    "jsonc",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "requirements",
    "rust",
    "scala",
    "sql",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
  },
  formatters = {
    "stylua",
    "isort",
    "black",
    "sql-formatter",
    "mdformat",
    "yamlfix",
    "shfmt",
    "prettier",
    "prettierd",
    "goimports",
    "gofumpt",
  },
  linters = {
    "vulture",
    "markdownlint",
    "shellcheck",
    "hadolint",
    "jsonlint",
    "golangci-lint",
    "yamllint",
    "sqlfluff",
  },
  tools = {
    "delve",
    "debugpy",
  },
}
