local dap_config = function()
  local dap, dapui = require("dap"), require("dapui")

  -- Get current buffer's filetype
  local function get_current_buf_filetype()
    return vim.bo[vim.api.nvim_get_current_buf()].filetype
  end

  -- Launch debugging session
  local function launch_debugging_session()
    local buf_filetype = get_current_buf_filetype()

    if buf_filetype == "lua" then
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
      d = {
        name = "debugging-session",

        l = { launch_debugging_session, "Launch debugging session" },
        r = { restart_debugging_session, "Restart current debugging session" },
        t = {
          function()
            dap.terminate()
          end,
          "Terminate debugging session",
        },
      },

      -- Breakpoint
      b = {
        function()
          dap.toggle_breakpoint()
        end,
        "Toggle breakpoint",
      },
      C = {
        function()
          dap.set_breakpoint(nil, nil, vim.fn.input("Condition: "))
        end,
        "Set conditional breakpoint",
      },

      -- Operation
      c = { dap_continue, "Continue execution" },
      o = { dap.step_over, "Step over" },
      i = { dap.step_into, "Step into" },
      R = { dap.run_to_cursor, "Run till cursor location" },

      -- Debugger UI
      u = { dapui.toggle, "Toggle debugger UI" },
      ["?"] = {
        function()
          dapui.eval({ nil, enter = true })
        end,
        "Show value of variable under cursor/highlight",
      },

      s = {
        name = "debugger-specific options",

        l = {
          function()
            require("osv").launch({ port = 8086 })
          end,
          "Launch neovim debugee instance",
        },
      },
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
