return {
  "numToStr/Comment.nvim",
  config = function ()
    require("Comment").setup({
      ignore = "^$",
    })
  end,
  event = "BufReadPost"
}
