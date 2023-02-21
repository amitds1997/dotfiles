local P = {}
P.__index = P

function P:init()
  self.utils = require("core.utils")
  self.data_path = vim.fn.stdpath("data")
  self.config_path = vim.fn.stdpath("config")
  self.module_path = self.utils.path_join(self.config_path, "lua", "modules")
end

-- Make sure that the package manager is installed
function P:ensure_lazy_nvim_installed()
  local lazy_path = self.utils.path_join(self.data_path, "lazy", "lazy.nvim")

  if vim.fn.isdirectory(lazy_path) == 0 then
    self.utils.log_info("Did not find the package manager - lazy.nvim - locally. Will install now.")
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_path
    })
    self.utils.log_success("Installed lazy.nvim successfully")
  end

  vim.opt.runtimepath:prepend(lazy_path)
end

function P:gather_packages_info()
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

function P:bootstrap()
  self:init()
  self:ensure_lazy_nvim_installed()

  local lazy = require("lazy")
  local lazy_opts = {
    ui = {
      border = "rounded"
    },
  }
  self:gather_packages_info()
  lazy.setup(self.repos, lazy_opts)
end

-- Function to start tracking a neovim plugin package
function P.package(repo)
  if not P.repos then
    P.repos = {}
  end
  table.insert(P.repos, repo)
end

return P
