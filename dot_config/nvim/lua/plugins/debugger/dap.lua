local dap_config = function()
  local dap, dapui = require("dap"), require("dapui")

  -- Launch debugging session
  local function launch_debugging_session()
    if vim.bo.filetype == "lua" then
      vim.ui.select({ "Launch the current file", "Launch connection with other debugger" }, {
        prompt = "Choose debugging method",
      }, function(choice)
        if choice == nil then
          return
        end

        if choice == "Launch the current file" then
          require("osv").run_this()
        elseif choice == "Launch connection with other debugger" then
          dap.continue()
        end
      end)
    else
      dap.continue()
    end
  end

  -- Restart debugging session
  local function restart_debugging_session()
    if dap.session() ~= nil and vim.bo.filetype == "lua" then
      dap.terminate()
      launch_debugging_session()
    else
      dap.restart()
    end
  end

  -- DAP continue session
  local function dap_continue()
    if vim.bo.filetype == "lua" and dap.session() == nil then
      launch_debugging_session()
    else
      dap.continue()
    end
  end

  vim.keymap.set("n", "<leader>b<C-j>", dap.up, { desc = "Move up the current stacktrace" })
  vim.keymap.set("n", "<leader>b<C-k>", dap.down, { desc = "Move up the current stacktrace" })
  vim.keymap.set("n", "<leader>b?", function()
    dapui.eval({ nil, enter = true })
  end, {
    desc = "Show value of variable under cursor/highlight",
  })
  vim.keymap.set("n", "<leader>bB", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Condition: "))
  end, {
    desc = "Set conditional breakpoint",
  })
  vim.keymap.set("n", "<leader>bC", dap.run_to_cursor, { desc = "Run till cursor location" })
  vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
  vim.keymap.set("n", "<leader>bc", dap_continue, { desc = "Continue execution" })
  vim.keymap.set("n", "<leader>bel", function()
    require("osv").launch({ port = 8086 })
  end, {

    desc = "Launch neovim debugee instance",
  })
  vim.keymap.set("n", "<leader>bi", dap.step_into, { desc = "Step into" })
  vim.keymap.set("n", "<leader>bo", dap.step_over, { desc = "Step over" })
  vim.keymap.set("n", "<leader>bsr", restart_debugging_session, { desc = "Re-start debug session" })
  vim.keymap.set("n", "<leader>bss", launch_debugging_session, { desc = "Start debug session" })
  vim.keymap.set("n", "<leader>bst", dap.terminate, { desc = "Terminate debug session" })
  vim.keymap.set("n", "<leader>bu", dapui.toggle, { desc = "Toggle debugger UI" })

  require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })
end

return {
  "mfussenegger/nvim-dap",
  event = "LspAttach",
  config = dap_config,
}
