local function buf_switcher()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #buffers <= 1 then
    vim.notify("Only one buffer is open")
    return
  end
  require("telescope.builtin").buffers()
end

return {
  ["<ESC>"] = { "<cmd>nohlsearch<CR>", "Remove active search highlight" },
  ["<TAB>"] = { buf_switcher, "Switch buffers using menu", mode = "v" },
  ["<S-TAB>"] = { buf_switcher, "Switch buffers using menu", mode = "v" },
  ["<S-Tab>"] = { "<C-d>", "De-tab", mode = "i" },

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
}
