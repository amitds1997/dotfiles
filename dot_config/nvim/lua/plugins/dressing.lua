return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = {
      win_options = {
        winblend = 0,
      },
      override = function(conf)
        conf.col = -1
        conf.row = 0
        return conf
      end,
    },
  },
}
