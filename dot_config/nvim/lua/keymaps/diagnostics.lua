return {
  ["[d"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Jump to previous diagnostic" },
  ["]d"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "Jump to next diagnostic" },
  ["<leader>d"] = {
    name = "Diagnostics",

    c = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Show diagnostic for the word under cursor" },
    l = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Show diagnostic for the line" },
    b = { "<cmd>Lspsaga show_buf_diagnostics<CR>", "Show diagnostic for the buffer" },
    w = { "<cmd>Lspsaga show_workspace_diagnostics<CR>", "Show diagnostic for the workspace" },
  },
}
