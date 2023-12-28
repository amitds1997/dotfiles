local function buf_switcher()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #buffers <= 1 then
    vim.notify("Only one buffer is open")
    return
  end
  require("telescope.builtin").buffers()
end

return {
  ["<TAB>"] = { buf_switcher, "Switch buffers using menu" },
  ["<S-TAB>"] = { buf_switcher, "Switch buffers using menu" },

  ["<leader>f"] = {
    name = "buffer",

    d = { "<cmd>bd<CR>", "Delete buffer" },
  },
}
