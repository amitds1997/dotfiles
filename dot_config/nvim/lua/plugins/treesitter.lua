local treesitter_config = function()
  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup({
    ensure_installed = require("core.vars").treesitter_parsers,
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(_, bufnr)
        local max_lines = 8000 -- Max 8000 lines will be rendered, else treesitter will be disabled
        local ok, stats = pcall(require("core.utils").uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if
          (ok and stats and stats.size > require("core.vars").max_filesize)
          or vim.api.nvim_buf_line_count(bufnr) > max_lines
        then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = false,
    },
    incremental_selection = {
      enable = true,
    },
  })

  ---@diagnostic disable-next-line: missing-fields
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

  -- Prefer Git over HTTPS
  require("nvim-treesitter.install").prefer_git = true

  -- Specify parser for specific file patterns
  vim.treesitter.language.register("gotmpl", "template")
  vim.treesitter.language.register("python", "pyn")
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
