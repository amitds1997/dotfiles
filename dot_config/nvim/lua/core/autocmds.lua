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

-- Clean up viewdir and undodir files older than 30 days
vim.api.nvim_create_autocmd({ "FocusLost" }, {
  once = true,
  callback = function()
    local view_dir = vim.fs.joinpath(vim.env.XDG_STATE_HOME, "nvim", "view")
    local undo_dir = vim.fs.joinpath(vim.env.XDG_STATE_HOME, "nvim", "undo")
    vim.system({ "find", view_dir, "-mtime", "+30d", "-delete" })
    vim.system({ "find", undo_dir, "-mtime", "+30d", "-delete" })
  end,
})

vim.api.nvim_create_autocmd({ "FocusLost", "InsertLeave", "BufLeave" }, {
  callback = function(ctx)
    local bufnr = ctx.buf
    local bo = vim.bo[bufnr]
    local b = vim.b[bufnr]

    -- We would debounce saves so that we do not make too many save requests
    if (b.save_queued and ctx.event ~= "FocusLost") or bo.buftype ~= "" or bo.ft == "gitcommit" or bo.readonly then
      return
    end

    local debounce_ms = ctx.event == "FocusLost" and 0 or 2000 -- Save immediately on focus lost
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("silent! noautocmd lockmarks update!")
      end)
      b.save_queued = false
    end, debounce_ms)
  end,
})
