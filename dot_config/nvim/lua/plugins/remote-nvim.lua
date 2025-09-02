---@module 'lazy'
---@type LazyPluginSpec
return {
  "amitds1997/remote-nvim.nvim",
  -- version = "*", -- Pin to GitHub releases
  branch = "main",
  enabled = false,
  -- dev = true,
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim", -- For standard functions
    "MunifTanjim/nui.nvim", -- To build the plugin UI
    "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
  },
  opts = {
    log = {
      level = "debug",
    },
  },
}
