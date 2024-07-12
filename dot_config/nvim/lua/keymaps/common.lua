-- Quickly switch b/w buffers using Tab/Shift-Tab
local function buf_switcher()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #buffers <= 1 then
    vim.notify("Only one buffer is open")
    return
  end
  require("telescope.builtin").buffers({
    show_all_buffers = false,
    select_current = true,
  })
end

return {
  ["<ESC>"] = { "<C-\\><C-n>", "Escape terminal into normal mode", mode = "t" },
  ["<TAB>"] = { buf_switcher, "Switch buffers using menu" },
  ["<S-TAB>"] = { buf_switcher, "Switch buffers using menu" },
  ["[d"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Jump to previous diagnostic" },
  ["]d"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "Jump to next diagnostic" },
  ["<leader>c"] = {
    name = "common-op",

    s = { "<cmd>mkview<CR>", "Save the current view of the buffer" },
    l = { "<cmd>loadview<CR>", "Restore previous saved view" },
    m = { "<cmd>Mason<CR>", "Open Mason" },
    n = { "<cmd>Noice dismiss<CR>", "Dismiss active notifications" },
    f = {
      function()
        vim.b.disable_autoformat = not (vim.b.disable_autoformat or false)
        if vim.b.disable_autoformat then
          vim.notify("Formatting disabled for the buffer")
        else
          vim.notify("Formatting re-enabled for the buffer")
        end
      end,
      "Toggle formatting status",
    },
    t = {
      "<cmd>ToggleTerm<CR>",
      "Toggle terminal",
    },
  },

  ["<leader>d"] = {
    name = "Diagnostics",

    c = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Show diagnostic for the word under cursor" },
    l = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Show diagnostic for the line" },
    b = { "<cmd>Lspsaga show_buf_diagnostics<CR>", "Show diagnostic for the buffer" },
    w = { "<cmd>Lspsaga show_workspace_diagnostics<CR>", "Show diagnostic for the workspace" },
  },

  ["<leader>g"] = {
    name = "git",

    n = {
      function()
        require("neogit").open()
      end,
      "Open Neogit",
    },
  },

  ["<leader>l"] = {
    name = "LSP",

    e = {
      name = "extras",

      i = {
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
            bufnr = 0,
          }), {
            bufnr = 0,
          })
        end,
        "Toggle LSP inlay hints",
      },
    },
  },

  ["<leader>z"] = {
    name = "lazy",
    z = { "<cmd>Lazy<CR>", "Open Lazy window" },
    s = { "<cmd>Lazy sync<CR>", "Sync all plugins" },
    u = { "<cmd>Lazy update<CR>", "Update all installed plugins" },
    p = { "<cmd>Lazy profile<CR>", "Open Lazy profile window" },
  },
}
