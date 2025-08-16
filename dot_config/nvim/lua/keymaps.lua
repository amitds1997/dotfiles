local set = require("core.utils").set_keymap

set("<TAB>", "<cmd>bnext<CR>", "Switch buffers (next)")
set("<S-TAB>", "<cmd>bprevious<CR>", "Switch buffers (next)")

set("<leader>mn", function()
  require("snacks").notifier.hide()
end, "Hide active notifications")

set("<C-h>", "<cmd>wincmd h<CR>", "Move to window towards left")
set("<C-j>", "<cmd>wincmd j<CR>", "Move to window towards bottom")
set("<C-k>", "<cmd>wincmd k<CR>", "Move to window towards top")
set("<C-l>", "<cmd>wincmd l<CR>", "Move to window towards right")

set("<leader>wq", "<cmd>close<CR>", "Close active window")
set("<leader>wo", "<cmd>only<CR>", "Close all except active window")

-- Handle search highlighting using <Esc>
vim.keymap.set({ "n", "v", "i" }, "<Esc>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd "nohlsearch"
  end
  return "<Esc>"
end, { expr = true, silent = true })

-- Handle delmarks
set("<leader>md", function()
  local arg = vim.fn.input "Which marks do you want to delete? "
  if arg ~= "" then
    vim.cmd("delmarks " .. arg .. " | redraw!")
  end
end, "Delete marks")
