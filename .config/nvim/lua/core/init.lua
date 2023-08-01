local L = {}
L.__index = L

-- Make sure that the package manager is installed
function L:ensure_lazy_nvim_installed()
  local lazy_path = require("core.utils").path_join(vim.fn.stdpath("data"), "lazy", "lazy.nvim")

  if vim.fn.isdirectory(lazy_path) == 0 then
    print("Did not find the package manager - lazy.nvim - locally. Will install now.")
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_path,
    })
    print("Installed lazy.nvim successfully")
  end

  vim.opt.runtimepath:prepend(lazy_path)
end

function L:bootstrap()
  self:ensure_lazy_nvim_installed()
  local lazy = require("lazy")

  require("lazy.core.cache").enable()
  require("core.options")

  local lazy_opts = {
    defaults = { lazy = true },
    ui = {
      border = "rounded",
    },
    install = {
      colorscheme = { "catppuccin", "habamax" },
    },
    checker = { enabled = true, notify = false },
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
    dev = {
      path = "~/personal/nvim-plugins/"
    }
  }
  lazy.setup("plugins", lazy_opts)

  if vim.fn.argc( -1) == 0 then
    -- autocmds and keymaps can wait to load
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("LazyVim", { clear = true }),
      pattern = "VeryLazy",
      callback = function ()
        require("core.autocmds")
        require("core.keymaps")
      end,
    })
  else
    require("core.autocmds")
    require("core.keymaps")
  end
end

return L
