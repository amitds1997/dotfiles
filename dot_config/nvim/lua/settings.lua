return {
  big_file = {
    size_in_bytes = 5 * 1024 * 1024,
    line_count = 50000,
  },
  ---@type boolean
  is_remote = vim.g.remote_neovim_host and true or false,
  colorscheme = {
    ---@type "tokyonight"|"catppuccin"|"rose-pine"
    name = "rose-pine",
    transparent_background = false,
  },
  meta_filetypes = {
    "",
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
}
