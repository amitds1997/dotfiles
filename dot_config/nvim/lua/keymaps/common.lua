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

    s = { "<cmd>setlocal spell!<CR>", "Toggle spellcheck" },
    l = { "<cmd>setlocal number!<CR>", "Toggle line number" },
    r = { "<cmd>setlocal relativenumber!<CR>", "Toggle relative line number" },
    m = { "<cmd>Mason<CR>", "Open Mason" },
    n = {
      function()
        require("notify").dismiss()
      end,
      "Dismiss active notifications",
    },
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
}
