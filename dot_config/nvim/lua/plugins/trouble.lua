return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    win_config = {
      border = "rounded"
    },
    auto_close = true,
    auto_jump = { "lsp_definitions", "lsp_references", "lsp_implementations" },
  }
}
