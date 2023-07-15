local treesitter_config = function ()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "bash",
      "c",
      "comment",
      "cpp",
      "dockerfile",
      "git_config",
      "git_rebase",
      "gitcommit",
      "gitignore",
      "go",
      "ini",
      "vimdoc",
      "json",
      "jsonc",
      "javascript",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "python",
      "regex",
      "scala",
      "sql",
      "typescript",
      "toml",
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

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = treesitter_config,
  event = "VeryLazy",
}
