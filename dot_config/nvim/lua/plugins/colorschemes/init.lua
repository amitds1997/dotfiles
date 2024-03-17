return require("core.utils").get_plugins(
  require("core.utils").path_join(vim.fn.stdpath("config"), "lua", "plugins", "colorschemes")
)
