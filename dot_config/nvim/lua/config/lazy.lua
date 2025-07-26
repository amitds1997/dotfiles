local lazyrepo = "https://github.com/folke/lazy.nvim.git"
local lazy_path = vim.fs.joinpath(vim.fn.stdpath "data", "lazy", "lazy.nvim")

if not vim.uv.fs_stat(lazy_path) then
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazy_path }
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

-- Configure lazy.nvim = package manager

-- local lazy_opts = {}
local lazy_opts = {
  -- defaults = {
  --   lazy = true,
  -- },
  dev = {
    path = vim.fs.joinpath(vim.env.HOME, "personal", "nvim-plugins"),
    fallback = true,
  },
  install = {
    missing = true,
  },
  change_detection = { notify = false },
  checker = { notify = false },
  ui = {
    border = "rounded",
  },
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = require("config.constants").disabled_plugins,
    },
  },
}

require("lazy").setup({
  { import = "plugins" },
  { import = "colorschemes" },
}, lazy_opts)

local skm = require("utils").set_keymap

skm("<leader>zz", function()
  vim.cmd "Lazy"
end, "Open Lazy window")
skm("<leader>zs", function()
  vim.cmd "Lazy sync"
end, "Sync installed plugins")
skm("<leader>zu", function()
  vim.cmd "Lazy update"
end, "Update all installed plugins")
skm("<leader>zp", function()
  vim.cmd "Lazy profile"
end, "Open Lazy profiler tab")
