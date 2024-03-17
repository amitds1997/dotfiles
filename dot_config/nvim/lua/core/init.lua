local L = {}
L.__index = L
local uv = require("core.utils").uv

-- Make sure that the package manager is installed
function L:ensure_lazy_nvim_installed()
  local lazy_path = require("core.utils").path_join(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
  local state = uv.fs_stat(lazy_path)

  if not state then
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
      missing = true,
      colorscheme = { require("core.vars").colorscheme, "habamax" },
    },
    change_detection = { notify = false },
    checker = { enabled = true, notify = false },
    performance = {
      rtp = {
        disabled_plugins = {
          "2html_plugin",
          "bugreport",
          "compiler",
          "ftplugin",
          "getscript",
          "getscriptPlugin",
          "gzip",
          "logipat",
          "matchit",
          "matchparen",
          "netrw",
          "netrwFileHandlers",
          "netrwPlugin",
          "netrwSettings",
          "optwin",
          "rplugin",
          "rrhelper",
          "spellfile_plugin",
          "synmenu",
          "syntax",
          "tar",
          "tarPlugin",
          "tohtml",
          "tutor",
          "vimball",
          "vimballPlugin",
          "zip",
          "zipPlugin",
        },
      },
    },
    dev = {
      path = "~/personal/nvim-plugins/",
      fallback = true,
    },
  }
  lazy.setup("plugins", lazy_opts)

  local function load_everything_else()
    require("core.autocmds")
    require("core.keymaps")
    require("core.diagnostics")
  end

  if vim.fn.argc(-1) == 0 then
    -- autocmds and keymaps can wait to load
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("LazyVim", { clear = true }),
      pattern = "VeryLazy",
      callback = load_everything_else,
    })
  else
    load_everything_else()
  end
end

return L
