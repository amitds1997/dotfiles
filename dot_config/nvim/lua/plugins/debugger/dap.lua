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

  require("which-key").register({
    ["<leader>b"] = {
      name = "debugger",

      s = {
        name = "session",

        s = { launch_debugging_session, "Start debug session" },
        r = { restart_debugging_session, "Re-start debug session" },
        t = { dap.terminate, "Terminate debug session" },
      },
      o = { dap.step_over, "Step over" },
      i = { dap.step_into, "Step into" },
      c = { dap_continue, "Continue execution" },
      C = { dap.run_to_cursor, "Run till cursor location" },
      b = {
        function()
          dap.toggle_breakpoint()
        end,
        "Toggle breakpoint",
      },
      B = {
        function()
          dap.set_breakpoint(nil, nil, vim.fn.input("Condition: "))
        end,
        "Set conditional breakpoint",
      },
      ["<C-j>"] = {
        dap.up,
        "Move up the current stacktrace",
      },
      ["<C-k>"] = {
        dap.down,
        "Move up the current stacktrace",
      },

      -- Debugger UI
      u = { dapui.toggle, "Toggle debugger UI" },
      ["?"] = {
        function()
          dapui.eval({ nil, enter = true })
        end,
        "Show value of variable under cursor/highlight",
      },

      -- Extras
      e = {
        name = "debugger-specific options",

        l = {
          function()
            require("osv").launch({ port = 8086 })
          end,
          "Launch neovim debugee instance",
        },
      },
    },
  }, {
    mode = { "n", "v" },
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
