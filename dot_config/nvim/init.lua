local lazyrepo = "https://github.com/folke/lazy.nvim.git"
local lazy_path = vim.fs.joinpath(vim.fn.stdpath "data", "lazy", "lazy.nvim")

if not (vim.uv or vim.loop).fs_stat(lazy_path) then
  vim.api.nvim_echo({
    {
      "Did not find the package manager. Trying to install it now...\n",
      "DiagnosticInfo",
    },
  }, true, {})
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazy_path }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  else
    vim.api.nvim_echo({
      { "Installed lazy.nvim successfully", "DiagnosticInfo" },
    }, true, {})
  end
end
vim.opt.rtp:prepend(lazy_path)

-- Set `mapleader` and `maplocalleader`
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set({ "n", "x", "v" }, vim.g.mapleader, "", { noremap = true })

require "core.options"
require "core.lazy"
require "autocmds"
require "diagnostics"
require "keymaps"
