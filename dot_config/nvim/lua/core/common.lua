-- Add filetype for custom file patterns/names
vim.filetype.add({
  filename = {
    [".eslintrc.json"] = "jsonc",
    [".luarc.json"] = "jsonc",
  },
  pattern = {
    [".*/hypr/.*%.conf"] = "hyprlang",
    ["tsconfig*.json"] = "jsonc",
    [".*/%.vscode/.*%.json"] = "jsonc",
  },
})

-- Many filetypes are not supposed to be edited and only provide some contextual information
-- Certain conveniences can be setup for such filetypes such as:
-- 1. Quit the buffer window using `q`
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("amitds1997/close_with_q", { clear = true }),
  pattern = require("core.vars").temp_filetypes,
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Keep neovim directories clean by:
-- 1. Cleaning up viewdir and undodir files older than 30 days
vim.api.nvim_create_autocmd({ "FocusLost" }, {
  group = vim.api.nvim_create_augroup("amitds1997/cleanup_old_files", { clear = true }),
  once = true,
  callback = function()
    local view_dir = vim.fs.joinpath(vim.env.XDG_STATE_HOME, "nvim", "view")
    local undo_dir = vim.fs.joinpath(vim.env.XDG_STATE_HOME, "nvim", "undo")

    vim.system({ "find", view_dir, "-mtime", "+30d", "-delete" })
    vim.system({ "find", undo_dir, "-mtime", "+30d", "-delete" })
  end,
})

-- Save buffer if there are changes regularly to avoid having to do :w so many times
-- vim.api.nvim_create_autocmd({ "FocusLost", "InsertLeave", "BufLeave" }, {
--   group = vim.api.nvim_create_augroup("amitds1997/autosave_buffers", { clear = true }),
--   callback = function(ctx)
--     local bufnr = ctx.buf
--     local bo = vim.bo[bufnr]
--     local b = vim.b[bufnr]

--     -- If possible, try not to save in sane scenarios
--     if (b.save_queued and ctx.event ~= "FocusLost") or bo.buftype ~= "" or bo.ft == "gitcommit" or bo.readonly then
--       return
--     end

--     -- Debounce save request by 2s unless it's a FocusLost event in which case do it on the next Neovim loop iteration
--     local debounce_ms = ctx.event == "FocusLost" and 0 or 2000
--     vim.defer_fn(function()
--       if not vim.api.nvim_buf_is_valid(bufnr) then
--         return
--       end
--       vim.api.nvim_buf_call(bufnr, function()
--         -- Instead of write call `update` to write only if the buffer is changed
--         vim.cmd("silent! noautocmd lockmarks update!")
--       end)
--       b.save_queued = false
--     end, debounce_ms)
--   end,
-- })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("amitds1997/yank_highlight", { clear = true }),
  desc = "Highlight text on being yanked",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      priority = 250,
    })
  end,
})

-- Remove padding around Neovim in terminal when background is not transparent
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then
      return
    end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function()
    io.write("\027]111\027\\")
  end,
})
