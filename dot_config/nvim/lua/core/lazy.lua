local lazy_repo = "https://github.com/folke/lazy.nvim.git"
local lazy_path = vim.fs.joinpath(vim.fn.stdpath "data", "lazy", "lazy.nvim")

if not vim.uv.fs_stat(lazy_path) then
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazy_repo, lazy_path }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazy_path)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Lazy.nvim = package manager
local lazy_opts = {
  defaults = {
    lazy = true,
  },
  dev = {
    path = vim.fs.joinpath(vim.env.HOME, "personal", "nvim-plugins"),
    fallback = false,
  },
  install = {
    missing = true,
  },
  change_detection = { notify = false },
  checker = { notify = false },
  ui = {
    border = "rounded",
    backdrop = 100,
  },
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = require("core.constants").disabled_plugins,
    },
  },
}

require("lazy").setup({
  { import = "plugins" },
  { import = "colorschemes" },
  { import = "lsp" },
}, lazy_opts)
