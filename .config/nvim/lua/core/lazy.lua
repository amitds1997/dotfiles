local L = {}
L.__index = L

function L:init()
  self.utils = require("core.utils")
  self.data_path = vim.fn.stdpath("data")
  self.config_path = vim.fn.stdpath("config")
  self.module_path = self.utils.path_join(self.config_path, "lua", "modules")
end

-- Make sure that the package manager is installed
function L:ensure_lazy_nvim_installed()
  local lazy_path = self.utils.path_join(self.data_path, "lazy", "lazy.nvim")

  if vim.fn.isdirectory(lazy_path) == 0 then
    self.utils.log_info("Did not find the package manager - lazy.nvim - locally. Will install now.")
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_path,
    })
    self.utils.log_success("Installed lazy.nvim successfully")
  end

  vim.opt.runtimepath:prepend(lazy_path)
end

function L:gather_packages_info()
  self.repos = {}

  local plugins_list = vim.split(vim.fn.glob(self.module_path .. "/plugins/*.lua"), "\n")
  if #plugins_list == 0 then
    return
  end

  for _, pkg in pairs(plugins_list) do
    local _, pkg_path = pkg:find(self.module_path)
    pkg = pkg:sub(pkg_path - 6, #pkg - 4)
    require(pkg)
  end
end

function L:bootstrap()
  self:init()
  self:ensure_lazy_nvim_installed()

  local lazy = require("lazy")
  local lazy_opts = {
    defaults = { lazy = true },
    ui = {
      border = "rounded",
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "2html_plugin",
          "getscript",
          "getscriptPlugin",
          "gzip",
          "logipat",
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "matchit",
          "matchparen",
          "tar",
          "tarPlugin",
          "tohtml",
          "rrhelper",
          "spellfile_plugin",
          "vimball",
          "vimballPlugin",
          "zip",
          "zipPlugin",
          "tutor",
          "rplugin",
          "syntax",
          "synmenu",
          "optwin",
          "compiler",
          "bugreport",
          "ftplugin",
        },
      },
    },
  }
  self:gather_packages_info()
  lazy.setup(self.repos, lazy_opts)
end

-- Function to start tracking a neovim plugin package
function L.package(repo)
  if not L.repos then
    L.repos = {}
  end
  table.insert(L.repos, repo)
end

return L
