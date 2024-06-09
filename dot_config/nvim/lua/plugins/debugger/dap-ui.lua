local dap_ui_config = function()
  local dap, dapui = require("dap"), require("dapui")

  dapui.setup({
    icons = {
      expanded = "⏷",
      collapsed = "⏵",
      current_frame = "⏵",
    },
    floating = {
      border = "rounded",
    },
    all_frames = true,
    show_stop_reason = true,
  })

  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
  end

  -- dap.listeners.after.event_initialized.dapui_config = function()
  --   dapui.open()
  -- end
  -- dap.listeners.before.disconnect.dapui_config = function()
  --   dapui.close()
  -- end

  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
  local signs = {
    {
      name = "DapStopped",
      text = "󰁕 ",
      texthl = "DiagnosticInfo",
      linehl = "DapStoppedLine",
      numhl = "DapStoppedLine",
    },
    { name = "DapBreakpoint", text = "󰘻 ", texthl = "DiagnosticError" },
    { name = "DapBreakpointRejected", text = " ", texthl = "DiagnosticBorder" },
    { name = "DapBreakpointCondition", text = "󰘻 ", texthl = "DiagnosticWarn" },
    { name = "DapLogPoint", text = "󰘾 ", texthl = "DiagnosticInfo" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, sign)
  end
end

return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    {
      "theHamsta/nvim-dap-virtual-text",
      config = true,
    },
    "nvim-neotest/nvim-nio",
  },
  config = dap_ui_config,
}
