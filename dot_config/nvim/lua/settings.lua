return {
  big_file = {
    size_in_bytes = 0.5 * 1024 * 1024, -- 500 KB
    line_count = 5000,
  },
  ---@type boolean
  is_remote = vim.g.remote_neovim_host and true or false,
  colorscheme = {
    ---@type "tokyonight"|"catppuccin"|"rose-pine"|"github-theme"
    name = "tokyonight",
    transparent_background = false,
  },
  meta_filetypes = {
    "",
    "PlenaryTestPopup",
    "TelescopePrompt",
    "checkhealth",
    "dbout",
    "gitcommit",
    "gitrebase",
    "gitsigns-blame",
    "help",
    "hgcommit",
    "lspinfo",
    "man",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "nofile",
    "notify",
    "oil",
    "prompt",
    "qf",
    "query",
    "sagafinder",
    "sagarename",
    "startuptime",
    "svn",
    "terminal",
    "tsplayground",
  },
}
