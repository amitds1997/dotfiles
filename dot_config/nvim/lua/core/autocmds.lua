-- Quit using `q` in following filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "checkhealth",
    "help",
    "lspinfo",
    "man",
    "nofile",
    "notify",
    "query",
    "prompt",
    "qf",
    "terminal",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
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

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    local mode = vim.fn.mode()
    if string.find(mode, "^[V\22]") then
      vim.wo.relativenumber = vim.wo.number
    else
      vim.wo.relativenumber = false
    end
  end,
  desc = "Toggle relative line numbers based on mode",
})
