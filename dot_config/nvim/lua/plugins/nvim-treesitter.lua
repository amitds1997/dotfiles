local ts_parsers = {
  "bash",
  "c",
  "comment",
  "cpp",
  "css",
  "csv",
  "diff",
  "dockerfile",
  "editorconfig",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "helm",
  "html",
  "http",
  "hyprlang",
  "ini",
  "javascript",
  "java",
  "json",
  "json5",
  "jsonc",
  "just",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "requirements",
  "rust",
  "scala",
  "scheme",
  "sql",
  "ssh_config",
  "terraform",
  "toml",
  "typescript",
  "vimdoc",
  "xml",
  "yaml",
}

---@module 'lazy'
---@type LazyPluginSpec
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile", "CmdlineEnter" },
  build = ":TSUpdate",
  opts = {
    ensure_installed = ts_parsers,
    highlight = {
      enable = true,
      disable = function(_, bufnr)
        return vim.bo[bufnr].filetype == "bigfile"
      end,
      additional_vim_regex_highlighting = false,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    vim.treesitter.language.register("gotmpl", "template")
    vim.treesitter.language.register("python", "pyn")
  end,
}
