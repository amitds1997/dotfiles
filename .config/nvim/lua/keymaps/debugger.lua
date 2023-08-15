local dap, dapui = require("dap"), require("dapui")

return {
  ["<leader>b"] = {
    name = "+debugger",

    b = { function () dap.toggle_breakpoint() end, "Toggle breakpoint" },
    s = { function () dap.set_breakpoint(nil, nil, vim.fn.input("Condition: ")) end, "Set conditional breakpoint" },
    c = { function () dap.continue() end, "Continue execution" },
    o = { function () dap.step_over() end, "Step over" },
    i = { function () dap.step_into() end, "Step into" },
    t = { function () dap.terminate() end, "Terminate debug session" },
    r = { function () dap.restart() end, "Restart current debug session" },
    l = { function () dap.run_last() end, "Re-run last debug configuration" },
    U = { function () dap.run_to_cursor() end, "Run till cursor location"},
    u = { function () dapui.toggle() end, "Toggle debugger UI" },
    R = { function () dap.repl.toggle() end, "Toggle REPL" },
  },
}
