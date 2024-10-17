local L = {}
L.__index = L

-- Make sure that the package manager is installed
function L:ensure_lazy_nvim_installed()
  ---@diagnostic disable-next-line: param-type-mismatch
  local lazy_path = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
  ---@diagnostic disable-next-line: undefined-field
  local state = vim.uv.fs_stat(lazy_path)

  if not state then
    vim.api.nvim_echo({
      {
        "Did not find the package manager - lazy.nvim - installed locally. Installing it now...\n\n",
        "DiagnosticInfo",
      },
    }, true, {})
    local ok, out = pcall(vim.fn.system, {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_path,
    })
    if not ok or vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim\n", "ErrorMsg" },
        { vim.trim(out or ""), "WarningMsg" },
        { "\nPress any key to exit...", "MoreMsg" },
      }, true, {})
      vim.fn.getchar()
      os.exit()
    else
      vim.api.nvim_echo({
        { "Installed lazy.nvim successfully", "DiagnosticInfo" },
      }, true, {})
    end
  end
  vim.opt.runtimepath:prepend(lazy_path)
end

function L:bootstrap()
  self:ensure_lazy_nvim_installed()
  -- Sane vim.options for my own setup
  require("core.options")

  local lazy_opts = {
    dev = {
      path = vim.fs.joinpath(vim.env.HOME, "personal", "nvim-plugins"),
      fallback = true,
    },
    defaults = { lazy = true },
    install = {
      missing = true,
      colorscheme = { require("core.vars").colorscheme, "habamax" },
    },
    ui = {
      border = "rounded",
      backdrop = 100,
      title = " Lazy 󰒲  ",
      icons = {
        cmd = " ",
        config = " ",
        event = " ",
        ft = " ",
        init = "󰅕 ",
        import = "󰋺 ",
        keys = "󰌓 ",
        lazy = "󰒲 ",
        loaded = "◍",
        not_loaded = "○",
        plugin = " ",
        runtime = require("core.constants").icons.NeovimIcon,
        require = " ",
        source = " ",
        start = " ",
        task = " ",
        list = {
          "●",
          "◍",
          "◌",
          "✹",
        },
      },
    },
    diff = {
      cmd = "terminal_git",
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
    profiling = {
      require = true,
    },
  }

  require("lazy").setup({
    { import = "plugins" },
    { import = "plugins.colorschemes" },
    { import = "plugins.debugger" },
  }, lazy_opts)

  local function load_everything_else()
    require("core.common")
    require("core.keymaps")
    require("core.diagnostics")
    require("utils")
  end

  -- If no arguments have been passed, then we can lazy load everything else we need to load everything NOW
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
