-- Quit using `q` in following filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = require("core.vars").ignore_buftypes,
  callback = function(event)
    -- vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Fix conceallevel for JSON files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})
