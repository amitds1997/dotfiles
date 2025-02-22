local lazy_opts = {
  dev = {
    path = vim.fs.joinpath(vim.env.HOME, "personal", "nvim-plugins"),
    fallback = true,
  },
  install = {
    missing = true,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = { notify = false },
  ui = {
    border = "rounded",
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
      runtime = require("constants").misc_icons.NeovimIcon,
      require = " ",
      source = " ",
      start = " ",
      task = " ",
      list = {
        "●",
        "⌾",
        "*",
        "-",
      },
    },
    custom_keys = {},
  },
  profiling = {
    require = true,
  },
  diff = {
    cmd = "terminal_git",
  },
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
