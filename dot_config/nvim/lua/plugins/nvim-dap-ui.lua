local dap_ui_config = function()
  local dap, dapui = require("dap"), require("dapui")

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.disconnect["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

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

  local sign = vim.fn.sign_define
  sign("DapBreakpoint", { text = "󰘻", texthl = "DapBreakpoint" })
  sign("DapBreakpointCondition", { text = "󰘻", texthl = "DapBreakpointCondition" })
  sign("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignWarn" })
  sign("DapStopped", { text = "󰁕", texthl = "DapStopped", linehl = "debugBreakpoint", numhl = "debugBreakpoint" })
  sign("DapLogPoint", { text = "󰘾", texthl = "DapLogPoint" })
end

return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    {
      "theHamsta/nvim-dap-virtual-text",
      config = true,
    },
  },
  config = dap_ui_config,
}
