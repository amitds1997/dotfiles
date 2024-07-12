return {
  "stevearc/dressing.nvim",
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
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.select(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.input(...)
    end
  end,
}
