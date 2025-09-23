---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

local dap_keymaps = {
  {
    "<leader>dB",
    function()
      require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
    end,
    desc = "Breakpoint Condition",
  },
  {
    "<leader>db",
    function()
      require("dap").toggle_breakpoint()
    end,
    desc = "Toggle Breakpoint",
  },
  {
    "<leader>dc",
    function()
      require("dap").continue()
    end,
    desc = "Run/Continue",
  },
  {
    "<leader>da",
    function()
      require("dap").continue { before = get_args }
    end,
    desc = "Run with Args",
  },
  {
    "<leader>dC",
    function()
      require("dap").run_to_cursor()
    end,
    desc = "Run to Cursor",
  },
  {
    "<leader>dg",
    function()
      require("dap").goto_()
    end,
    desc = "Go to Line (No Execute)",
  },
  {
    "<leader>di",
    function()
      require("dap").step_into()
    end,
    desc = "Step Into",
  },
  {
    "<leader>dj",
    function()
      require("dap").down()
    end,
    desc = "Down",
  },
  {
    "<leader>dk",
    function()
      require("dap").up()
    end,
    desc = "Up",
  },
  {
    "<leader>dl",
    function()
      require("dap").run_last()
    end,
    desc = "Run Last",
  },
  {
    "<leader>dO",
    function()
      require("dap").step_out()
    end,
    desc = "Step Out",
  },
  {
    "<leader>do",
    function()
      require("dap").step_over()
    end,
    desc = "Step Over",
  },
  {
    "<leader>dP",
    function()
      require("dap").pause()
    end,
    desc = "Pause",
  },
  {
    "<leader>dr",
    function()
      require("dap").repl.toggle()
    end,
    desc = "Toggle REPL",
  },
  {
    "<leader>ds",
    function()
      require("dap").session()
    end,
    desc = "Session",
  },
  {
    "<leader>dt",
    function()
      require("dap").terminate()
    end,
    desc = "Terminate",
  },
  {
    "<leader>dK",
    function()
      require("dap.ui.widgets").hover()
    end,
    desc = "Widgets",
  },
}

---@module 'lazy'
---@type LazyPluginSpec[]
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", config = true },
      "nvim-lua/plenary.nvim",
      {
        "igorlfs/nvim-dap-view",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {
          winbar = {
            controls = {
              enabled = true,
            },
          },
          windows = {
            terminal = {
              position = "right",
              width = 0.4,
            },
          },
          auto_toggle = "keep_terminal",
        },
      },
      "mfussenegger/nvim-dap-python",
    },
    keys = dap_keymaps,
    config = function()
      -- Signs
      for name, sign in pairs(require("core.constants").dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          ---@diagnostic disable-next-line: assign-type-mismatch
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- Decide when and how to jump when stopping for a breakpoint
      -- 1. If visible, do nothing
      -- 2. If buffer is open in another tab, open it there
      -- 3. Else, open in a new tab
      require("dap").defaults.fallback.switchbuf = "usevisible,usetab,newtab"

      -- Set up debug adapters
      require("dap-python").setup(vim.fn.exepath "debugpy-adapter")

      -- Set up any DAP configs in VSCode's launch.json file
      local vscode = require "dap.ext.vscode"
      local json = require "plenary.json"
      ---@diagnostic disable-next-line: duplicate-set-field
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      if MiniClue ~= nil then
        -- Set up hydra keymaps for debugging
        local dap_clues = {}
        for _, keymap in ipairs(dap_keymaps) do
          local key = keymap[1]
          if
            vim.tbl_contains({
              "<leader>do",
              "<leader>dO",
              "<leader>dC",
              "<leader>dg",
              "<leader>di",
              "<leader>dj",
              "<leader>dk",
              "<leader>dK",
            }, key)
          then
            table.insert(dap_clues, {
              { mode = "n", keys = keymap[1], postkeys = "<leader>d" },
            })
          end
        end
        vim.list_extend(MiniClue.config.clues, dap_clues)
      else
        vim.notify("MiniClue has not been set up so far, so hydra debug won't work", vim.log.levels.WARN)
      end
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
      },
    },
  },
}
