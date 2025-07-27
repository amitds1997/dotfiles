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
  "scheme",
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
        return vim.bo[bufnr].filetype == "bigfile"
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
