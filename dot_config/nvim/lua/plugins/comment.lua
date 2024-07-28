return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      enable_autocmd = false,
    },
    config = function(_, opts)
      vim.g.skip_ts_context_commentstring_module = true
      require("ts_context_commentstring").setup(opts)
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("Comment").setup({
        ignore = "^$",
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
    event = "BufReadPost",
    dependencies = {
      {},
    },
  },
}
