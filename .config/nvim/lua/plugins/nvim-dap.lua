local dap_config = function ()
  local dap = require("dap")

  vim.keymap.set("n", "<Leader>db", function () dap.toggle_breakpoint() end, { desc = "[d]ebugger: Toggle [b]reakpoint" })
  vim.keymap.set("n", "<Leader>dc", function () dap.continue({}) end, { desc = "[d]ebugger: [c]ontinue" })
  vim.keymap.set("n", "<Leader>do", function () dap.step_over() end, { desc = "[d]ebugger: step [o]ver" })
  vim.keymap.set("n", "<Leader>di", function () dap.step_into() end, { desc = "[d]ebugger: step [i]nto" })
  vim.keymap.set("n", "<Leader>dr", function () dap.repl.toggle() end, { desc = "[d]ebugger: toggle [r]epl" })
end

return {
  "mfussenegger/nvim-dap",
  cmd = {
    "DapSetLogLevel",
    "DapShowLog",
    "DapContinue",
    "DapToggleBreakpoint",
    "DapToggleRepl",
    "DapStepOver",
    "DapStepInto",
    "DapStepOut",
    "DapTerminate",
  },
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      config = require("plugins.dap.nvim-dap-ui"),
    },
    {
      "jbyuki/one-small-step-for-vimkind",
      config = require("plugins.dap.adapters.lua"),
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      config = require("plugins.dap.nvim-dap-virtual-text"),
    },
  },
  config = dap_config,
  keys = { "<Leader>db", "<Leader>dc", "<Leader>du", "<Leader>dld" },
}
