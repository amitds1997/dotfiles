-- Quickly switch b/w buffers using Tab/Shift-Tab
local function buf_switcher()
  local buffers = vim.fn.getbufinfo { buflisted = 1 }
  if #buffers <= 1 then
    vim.notify "Only one buffer is open"
    return
  end

  require("snacks").picker.buffers {
    nofile = false,
  }
end

local res = {
  { "<TAB>", buf_switcher, "Switch buffers using menu" },
  { "<S-TAB>", buf_switcher, "Switch buffers using menu" },
  { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Jump to previous diagnostic" },
  { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Jump to next diagnostic" },
  { "<leader>cs", "<cmd>mkview<CR>", "Save the current view of the buffer" },
  { "<leader>cl", "<cmd>loadview<CR>", "Restore previous saved view" },
  { "<leader>cm", "<cmd>Mason<CR>", "Open Mason" },
  {
    "<leader>cn",
    function()
      require("snacks").notifier.hide()
    end,
    "Dismiss active notifications",
  },
  {
    "<leader>ct",
    function()
      require("snacks").terminal()
    end,
    "Toggle terminal",
  },
  {
    "<leader>cf",
    function()
      vim.b.disable_autoformat = not (vim.b.disable_autoformat or false)
      if vim.b.disable_autoformat then
        vim.notify "Formatting disabled for the buffer"
      else
        vim.notify "Formatting re-enabled for the buffer"
      end
    end,
    "Toggle formatting status",
  },
  { "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Show diagnostic for the word under cursor" },
  { "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", "Show diagnostic for the line" },
  { "<leader>db", "<cmd>Lspsaga show_buf_diagnostics<CR>", "Show diagnostic for the buffer" },
  { "<leader>dw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", "Show diagnostic for the workspace" },
  { "<C-h>", "<cmd>wincmd h<CR>", "Move to window on left" },
  { "<C-k>", "<cmd>wincmd k<CR>", "Move to window on top" },
  { "<C-l>", "<cmd>wincmd l<CR>", "Move to window on right" },
  { "<C-j>", "<Cmd>wincmd j<CR>", "Move to window on bottom" },

  -- Adjust window size
  { "<C-,>", "<cmd>wincmd ><CR>", "Increase window size towards left" },
  { "<C-.>", "<cmd>wincmd <<CR>", "Increase window size towards right" },
  { "+", "<cmd>wincmd +<CR>", "Increase window size towards top" },
  { "-", "<cmd>wincmd -<CR>", "Increase window size towards bottom" },
  { "=", "<cmd>wincmd =<CR>", "Restore default window size" },

  { "<leader>wq", "<cmd>close<CR>", "Close window" },
  { "<leader>wo", "<cmd>only<CR>", "Close every other window except current" },
}

require("which-key").add {
  { "<leader>c", group = "Common-op", icon = "󰵫 " },
  { "<leader>d", group = "Diagnostics" },
  { "<leader>g", group = "Gitsigns", icon = " " },
  { "<leader>ge", group = "+gitsigns-extras", icon = "󰌉 " },
  { "<leader>gt", group = "+gitsigns-toggle", icon = "󰨙  " },
  { "<leader>l", group = "LSP", icon = "  " },
  { "<leader>lc", group = "+lsp-code-call", icon = "󰃸 " },
  { "<leader>ld", group = "+lsp-document", icon = "󰧮  " },
  { "<leader>le", group = "+lsp-extras", icon = "󰌉 " },
  { "<leader>lg", group = "+lsp-go-to", icon = "  " },
  { "<leader>lp", group = "+lsp-peek", icon = "  " },
  { "<leader>ls", group = "+lsp-symbol", icon = "  " },
  { "<leader>lw", group = "+lsp-workspace", icon = "  " },
  { "<leader>t", group = "Toggle", icon = "󰔡 " },
  { "<leader>p", group = "Picker", icon = "⛏ " },
  { "<leader>pg", group = "Git picker", icon = " " },
  { "<leader>pg", group = "History picker", icon = " " },
  { "<leader>w", group = "Window-op", icon = " " },
  { "<leader>z", group = "Lazy", icon = "󰒲  " },
}

for _, item in ipairs(res) do
  local lhs = item[1]
  local rhs = item[2]
  local desc = item[3]
  require("utils").set_keymap(lhs, rhs, desc)
end
