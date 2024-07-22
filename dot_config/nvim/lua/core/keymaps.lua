-- Quickly switch b/w buffers using Tab/Shift-Tab
local function buf_switcher()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #buffers <= 1 then
    vim.notify("Only one buffer is open")
    return
  end
  require("telescope.builtin").buffers({
    show_all_buffers = false,
    select_current = true,
  })
end

local function set_keymap(mode, lhs, rhs, desc)
  mode = mode or "n"
  vim.validate({
    mode = { mode, { "string", "table" } },
    desc = { desc, "string" },
  })
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

local res = {
  { "<TAB>", buf_switcher, desc = "Switch buffers using menu" },
  { "<S-TAB>", buf_switcher, desc = "Switch buffers using menu" },
  { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Jump to previous diagnostic" },
  { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Jump to next diagnostic" },
  { "<leader>cs", "<cmd>mkview<CR>", desc = "Save the current view of the buffer" },
  { "<leader>cl", "<cmd>loadview<CR>", desc = "Restore previous saved view" },
  { "<leader>cm", "<cmd>Mason<CR>", desc = "Open Mason" },
  { "<leader>cn", "<cmd>Noice dismiss<CR>", desc = "Dismiss active notifications" },
  {
    "<leader>cf",
    function()
      vim.b.disable_autoformat = not (vim.b.disable_autoformat or false)
      if vim.b.disable_autoformat then
        vim.notify("Formatting disabled for the buffer")
      else
        vim.notify("Formatting re-enabled for the buffer")
      end
    end,
    desc = "Toggle formatting status",
  },
  { "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Show diagnostic for the word under cursor" },
  { "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Show diagnostic for the line" },
  { "<leader>db", "<cmd>Lspsaga show_buf_diagnostics<CR>", desc = "Show diagnostic for the buffer" },
  { "<leader>dw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", desc = "Show diagnostic for the workspace" },
  {
    "<leader>lei",
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
        bufnr = 0,
      }), {
        bufnr = 0,
      })
    end,
    desc = "Toggle LSP inlay hints",
  },
  { "<leader>zz", "<cmd>Lazy<CR>", desc = "Open Lazy window" },
  { "<leader>zs", "<cmd>Lazy sync<CR>", desc = "Sync all plugins" },
  { "<leader>zu", "<cmd>Lazy update<CR>", desc = "Update all installed plugins" },
  { "<leader>zp", "<cmd>Lazy profile<CR>", desc = "Open Lazy profile window" },
  { "<C-h>", "<cmd>wincmd h<CR>", desc = "Move to window on left" },
  { "<C-k>", "<cmd>wincmd k<CR>", desc = "Move to window on top" },
  { "<C-l>", "<cmd>wincmd l<CR>", desc = "Move to window on right" },
  { "<C-j>", "<Cmd>wincmd j<CR>", desc = "Move to window on bottom" },

  -- Adjust window size
  { "<C-,>", "<cmd>wincmd ><CR>", desc = "Increase window size towards left" },
  { "<C-.>", "<cmd>wincmd <<CR>", desc = "Increase window size towards right" },
  { "+", "<cmd>wincmd +<CR>", desc = "Increase window size towards top" },
  { "-", "<cmd>wincmd -<CR>", desc = "Increase window size towards bottom" },
  { "=", "<cmd>wincmd =<CR>", desc = "Restore default window size" },

  { "<leader>wq", "<cmd>close<CR>", desc = "Close window" },
  { "<leader>wo", "<cmd>only<CR>", desc = "Close every other window except current" },
  {
    "<leader>we",
    function()
      require("oil").toggle_float()
    end,
    desc = "Open directory explorer",
  },
}

require("which-key").add({
  { "<leader>b", group = "Debugger" },
  { "<leader>be", group = "+debug-extras" },
  { "<leader>bs", group = "+debug-session" },
  { "<leader>c", group = "Common-op" },
  { "<leader>d", group = "Diagnostics" },
  { "<leader>g", group = "Gitsigns" },
  { "<leader>ge", group = "+gitsigns-extras" },
  { "<leader>gt", group = "+gitsigns-toggle" },
  { "<leader>l", group = "LSP" },
  { "<leader>lc", group = "+lsp-code-call" },
  { "<leader>ld", group = "+lsp-document" },
  { "<leader>le", group = "+lsp-extras" },
  { "<leader>lg", group = "+lsp-go-to" },
  { "<leader>lp", group = "+lsp-peek" },
  { "<leader>ls", group = "+lsp-symbol" },
  { "<leader>lw", group = "+lsp-workspace" },
  { "<leader>t", group = "Telescope" },
  { "<leader>w", group = "Window-op" },
  { "<leader>z", group = "Lazy" },
})

for _, item in ipairs(res) do
  local lhs = item[1]
  local rhs = item[2]
  set_keymap("n", lhs, rhs, item["desc"])
end
