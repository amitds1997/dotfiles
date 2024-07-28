return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded", icons = require("nvim-nonicons.extentions.mason").icons },
      pip = {
        upgrade_pip = true,
      },
      PATH = "append",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = not require("core.vars").is_remote,
    event = { "BufReadPost" },
    config = function()
      local auto_install_list = {}
      vim.list_extend(auto_install_list, require("core.vars").tools)
      vim.list_extend(auto_install_list, require("core.vars").linters)
      vim.list_extend(auto_install_list, require("core.vars").formatters)

      require("mason-tool-installer").setup({
        ensure_installed = auto_install_list,
        debounce_hours = 1,
        start_delay = 3000,
      })
    end,
  },
}
