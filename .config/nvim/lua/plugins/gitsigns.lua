return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signcolumn = true,
    numhl = true,
    diff_opts = { internal = true },
  },
  event = { "BufRead", "BufNewFile" },
}
