local treesitter_config = function ()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "bash",
      "c",
      "comment",
      "cpp",
      "dap_repl",
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
      disable = function (_, bufnr)
        local max_filesize = 1024 * 1024 -- 1 MiB
        local max_lines = 15000          -- Max 15000 lines will be rendered, else treesitter will be disabled
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if (ok and stats and stats.size > max_filesize) or vim.api.nvim_buf_line_count(bufnr) > max_lines then
          return true
        end
      end,
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
  dependencies = {
    {
      "LiadOz/nvim-dap-repl-highlights",
      config = true,
    }
  }
}
