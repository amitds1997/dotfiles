local ns = vim.api.nvim_create_namespace("DiagnosticCurLine")

-- We only show the diagnostic messages only on the current line but show signs in the statusline for all diagnostics.
-- So, we have to set virtual_text to false to set our own extmarks.
vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = require("core.constants").severity_icons,
  },
  virtual_text = false,
})

local function set_current_line_only_diagnostics(bufnr)
  vim.api.nvim_create_autocmd({ "CursorMoved", "DiagnosticChanged" }, {
    buffer = bufnr,
    callback = function(args)
      -- If the buffer is not the active buffer, no additional diagnostic decorations needed
      if args.buf ~= vim.api.nvim_get_current_buf() then
        return
      end

      -- To generate the diagnostics:
      -- 1. Remove any existing extmarks added in the buffer in the namespace
      vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)

      -- 2. Get diagnostics for the current line
      local curline = vim.api.nvim_win_get_cursor(0)[1]
      local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })

      -- 3. Generate the virtual text from the diagnostic message
      local virt_texts = { { (" "):rep(4) } }
      for _, diag in ipairs(diagnostics) do
        local diag_level = vim.diagnostic.severity[diag.severity]
        virt_texts[#virt_texts + 1] =
          { (" "):rep(2) .. diag.message, "DiagnosticVirtualText" .. diag_level:sub(1, 1) .. diag_level:sub(2):lower() }
      end

      -- 4. If the buffer is still the current buffer, set the extmarks
      if args.buf == vim.api.nvim_get_current_buf() then
        vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
          virt_text = virt_texts,
          hl_mode = "combine",
        })
      end
    end,
  })
end

-- Show diagnostic messages only for the current line for an LSP-attached buffer
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    set_current_line_only_diagnostics(args.buf)
  end,
})
