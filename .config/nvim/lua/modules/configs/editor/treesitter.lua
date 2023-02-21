return function ()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "bash",
      "dockerfile",
      "gitcommit",
      "gitignore",
      "help",
      "json",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "python",
      "scala",
      "vim",
      "yaml",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
    },
  })

  require("nvim-treesitter.install").prefer_git = true
end
