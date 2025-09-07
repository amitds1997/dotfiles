local leet_arg = "leetcode.nvim"

return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  lazy = leet_arg ~= vim.fn.argv(0, -1),
  cmd = "Leet",
  dev = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>ml",
      function()
        vim.cmd.Leet()
      end,
      desc = "Launch Leetcode",
    },
  },
  opts = {
    lang = "python3",
    picker = { provider = "mini-picker" },
  },
  config = function(_, opts)
    require("leetcode").setup(opts)
  end,
}
