return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({
      ignore = "^$",
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
  end,
  event = "BufReadPost",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      config = function()
        vim.g.skip_ts_context_commentstring_module = true
        require("ts_context_commentstring").setup({
          enable_autocmd = false,
        })
      end,
    },
  },
}
