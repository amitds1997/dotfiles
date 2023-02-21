return function ()
  local dap = require("dap")

  vim.keymap.set("n", "<Leader>db", function () dap.toggle_breakpoint() end, { desc = "[d]ebugger: Toggle [b]reakpoint" })
  vim.keymap.set("n", "<Leader>dc", function () dap.continue({}) end, { desc = "[d]ebugger: [c]ontinue" })
  vim.keymap.set("n", "<Leader>do", function () dap.step_over() end, { desc = "[d]ebugger: step [o]ver" })
  vim.keymap.set("n", "<Leader>di", function () dap.step_into() end, { desc = "[d]ebugger: step [i]nto" })
  vim.keymap.set("n", "<Leader>dr", function () dap.repl.toggle() end, { desc = "[d]ebugger: toggle [r]epl" })
  -- vim.keymap.set("n", "<leader>dw", function () require("dap.ui.widgets").hover() end, { desc = "[d]ebugger: open [w]idgets" })
end
