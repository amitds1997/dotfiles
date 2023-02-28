vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, noremap = true })

vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true, noremap = true, desc = "Jump to next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true, noremap = true, desc = "Jump to previous buffer" })

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- vim.keymap.set("n", "<Leader>h", ":nohlsearch<CR>", { silent = true, noremap = true })
