local settings = require "settings"

local formatters = {
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
}
local linters = {
  "vulture",
  "markdownlint",
  "shellcheck",
  "hadolint",
  "jsonlint",
  "golangci-lint",
  "yamllint",
  "sqlfluff",
}
local tools = {
  "delve",
  "debugpy",
}

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded", icons = require("nvim-nonicons.extentions.mason").icons },
      pip = {
        upgrade_pip = true,
      },
      PATH = "append",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = not settings.is_remote,
    event = { "BufReadPost" },
    config = function()
      local auto_install_list = {}
      vim.list_extend(auto_install_list, formatters)
      vim.list_extend(auto_install_list, linters)
      vim.list_extend(auto_install_list, tools)

      require("mason-tool-installer").setup {
        ensure_installed = auto_install_list,
        debounce_hours = 1,
        start_delay = 3000,
      }
    end,
  },
}
