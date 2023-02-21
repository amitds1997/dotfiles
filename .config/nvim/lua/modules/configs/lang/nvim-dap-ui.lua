return function ()
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

  vim.keymap.set("n", "<Leader>du", function () dapui.toggle() end, { desc = "[d]ebugger: toggle dap [u]i" })

  -- UI configuration
  local sign = vim.fn.sign_define

  sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
  sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
end
