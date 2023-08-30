local dap_config = function ()
  local dap, dapui = require("dap"), require("dapui")

  -- Get current buffer's filetype
  local function get_current_buf_filetype()
    return vim.bo[vim.api.nvim_get_current_buf()].filetype
  end

  -- Launch debugging session
  local function launch_debugging_session()
    local buf_filetype = get_current_buf_filetype()

    if buf_filetype == "lua" then
      require("osv").run_this()
    else
      dap.continue()
    end
  end

  -- Restart debugging session
  local function restart_debugging_session()
    local buf_filetype = get_current_buf_filetype()

    if dap.session() ~= nil and buf_filetype == "lua" then
      dap.terminate()
      launch_debugging_session()
    else
      dap.restart()
    end
  end

  -- DAP continue session
  local function dap_continue()
    local buf_filetype = get_current_buf_filetype()

    if buf_filetype == "lua" and dap.session() == nil then
      launch_debugging_session()
    else
      dap.continue()
    end
  end

  require("which-key").register({
    ["<leader>b"] = {
      name = "debugger",

      -- Session management
      s = {
        name = "debugging-session",

        l = { launch_debugging_session, "Launch debugging session" },
        r = { restart_debugging_session, "Restart current debugging session" },
        t = { function () dap.terminate() end, "Terminate debugging session" },
      },

      -- Breakpoint
      b = { function () dap.toggle_breakpoint() end, "Toggle breakpoint" },
      C = { function () dap.set_breakpoint(nil, nil, vim.fn.input("Condition: ")) end, "Set conditional breakpoint" },

      -- Operation
      c = { dap_continue, "Continue execution" },
      o = { function () dap.step_over() end, "Step over" },
      i = { function () dap.step_into() end, "Step into" },
      R = { function () dap.run_to_cursor() end, "Run till cursor location" },

      -- Debugger UI
      u = { function () dapui.toggle() end, "Toggle debugger UI" },
    },
  })

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
