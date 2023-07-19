vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, noremap = true })

-- Resize windows successfully
vim.keymap.set("n", "<C-.>", "<C-w>>", { silent = true, noremap = true, desc = "Increase window size to left" })
vim.keymap.set("n", "<C-,>", "<C-w><", { silent = true, noremap = true, desc = "Increase window size to right" })
vim.keymap.set("n", "+", "<C-w>+", { silent = true, noremap = true, desc = "Increase window size vertically" })
vim.keymap.set("n", "-", "<C-w>-", { silent = true, noremap = true, desc = "Decrease window size vertically" })

-- Delete buffer on command
vim.keymap.set("n", "dcb", ":BufDel<CR>", { silent = true, noremap = true, desc = "Delete current buffer" })

vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true, noremap = true, desc = "Jump to next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true, noremap = true, desc = "Jump to previous buffer" })

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
