local T = {}

T.start = function()
  vim.g.custom_term_bufnr = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_open_win(vim.g.custom_term_bufnr, true, {
    height = 10,
    style = "minimal",
    split = "below",
    vertical = true,
  })
  vim.cmd.terminal()
end

T.toggle = function()
  local possible_winid = vim.g.custom_term_bufnr and vim.fn.bufwinid(vim.g.custom_term_bufnr) or -1
  if possible_winid ~= -1 then
    vim.api.nvim_win_hide(possible_winid)
  else
    T.start()
  end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if vim.g.custom_term_bufnr and vim.api.nvim_buf_is_valid(vim.g.custom_term_bufnr) then
      vim.api.nvim_buf_delete(vim.g.custom_term_bufnr, {
        force = true,
        unload = true,
      })
    end
  end,
})

vim.keymap.set("n", "<Leader>ct", T.toggle, { desc = "Toggle terminal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Jump to normal mode" })

return T
