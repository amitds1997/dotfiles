local dap_config = function ()
  local dap, dapui = require("dap"), require("dapui")

  dap.listeners.after.event_initialized["dapui_config"] = function ()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function ()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function ()
    dapui.close()
  end

  dapui.setup({
    floating = {
      border = "rounded"
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
  "mfussenegger/nvim-dap",
  dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
  },
  config = dap_config,
}
