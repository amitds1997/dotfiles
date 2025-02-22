local treesitter_parsers = {
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
}

local function ts_setup()
  local opts = {
    ensure_installed = treesitter_parsers,
    highlight = {
      enable = true,
      disable = function(_, bufnr)
        local big_file_constraints = require("settings").big_file

        -- Check if number of lines exceed max
        if vim.api.nvim_buf_line_count(bufnr) > big_file_constraints.line_count then
          return true
        end

        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > big_file_constraints.size_in_bytes then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },
  }
  require("nvim-treesitter.configs").setup(opts)

  vim.treesitter.language.register("gotmpl", "template")
  vim.treesitter.language.register("python", "pyn")
end

return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile", "CmdlineEnter" },
  build = ":TSUpdate",
  config = ts_setup,
}
