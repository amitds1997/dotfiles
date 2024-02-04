local treesitter_config = function()
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
      disable = function(_, bufnr)
        local max_filesize = 1024 * 1024 -- 1 MiB
        local max_lines = 15000 -- Max 15000 lines will be rendered, else treesitter will be disabled
        local ok, stats = pcall(require("core.utils").uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
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

  -- require("nvim-treesitter.install").prefer_git = true

  require("nvim-treesitter.configs").setup({
    textobjects = {
      swap = {
        enable = true,
        swap_next = {
          ["<leader>rpn"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>rpp"] = "@parameter.inner",
        },
      },
    },
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = treesitter_config,
  event = { "BufReadPost", "BufNewFile", "CmdlineEnter" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}
