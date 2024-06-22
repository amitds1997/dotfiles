local ns = vim.api.nvim_create_namespace("DiagnosticCurLine")

local function set_diagnostics(bufnr)
  vim.api.nvim_create_autocmd({ "CursorMoved", "DiagnosticChanged" }, {
    buffer = bufnr,
    callback = function(args)
      if args.buf ~= vim.api.nvim_get_current_buf() then
        return
      end
      vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)
      local curline = vim.api.nvim_win_get_cursor(0)[1]
      local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })

      local virt_texts = { { (" "):rep(4) } }
      for _, diag in ipairs(diagnostics) do
        local diag_level = vim.diagnostic.severity[diag.severity]
        virt_texts[#virt_texts + 1] =
          { (" "):rep(2) .. diag.message, "DiagnosticVirtualText" .. diag_level:sub(1, 1) .. diag_level:sub(2):lower() }
      end
      if args.buf == vim.api.nvim_get_current_buf() then
        vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
          virt_text = virt_texts,
          hl_mode = "combine",
        })
      end
    end,
  })
end

vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = require("core.constants").severity_icons,
  },
  virtual_text = false,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    set_diagnostics(args.buf)
  end,
})
