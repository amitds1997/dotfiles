return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewClose" },
    },
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    graph_style = "unicode",
    console_timeout = 30000,
    integrations = {
      diffview = true,
    },
  },
}
