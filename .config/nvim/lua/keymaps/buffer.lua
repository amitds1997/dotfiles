return {
  ["<TAB>"] = { require("custom.buf_switcher").get_buffer_menu, "Switch buffers using menu" },
  ["<S-TAB>"] = { require("custom.buf_switcher").get_buffer_menu, "Switch buffers using menu" },

  ["<leader>f"] = {
    name = "buffer",

    d = { "<cmd>bd<CR>", "Delete buffer" }
  }
}
