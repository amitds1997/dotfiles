---@module 'lazy'
---@type LazyPluginSpec
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    -- FIX: Workaround till https://github.com/folke/which-key.nvim/issues/967
    show_help = false,
    win = {
      no_overlap = false,
      height = { min = 5 },
    },
    icons = {
      mappings = false,
      separator = "➔",
      keys = {
        Up = "󰜹 ",
        Down = "󰜰 ",
        Left = "󰜳 ",
        Right = "󰜶 ",
        Esc = "󱊷 ",
        D = "󰘳 ",
        C = " ",
        M = "󰘵 ",
        S = "󰘶 ",
        CR = "󰌑 ",
        NL = "󰌑 ",
        ScrollWheelDown = "󱕐 ",
        ScrollWheelUp = "󱕑 ",
        Space = "󱁐 ",
        Tab = "󰌒 ",
      },
    },
  },
  config = function(_, opts)
    local wk = require "which-key"
    wk.setup(opts)

    wk.add {
      { "<leader>a", group = "AI" },
      { "<leader>d", group = "Debugging" },
      { "<leader>e", group = "Extras" },
      { "<leader>g", group = "Git", mode = { "n", "v" } },
      { "<leader>go", group = "Open remote", mode = { "n", "v" } },
      { "<leader>l", group = "LSP" },
      { "<leader>lc", group = "Codelens" },
      { "<leader>m", group = "Miscellaneous", mode = { "n", "v" } },
      { "<leader>p", group = "Picker" },
      { "<leader>ph", group = "Picker history" },
      { "<leader>t", group = "Toggle" },
      { "<leader>w", group = "Window" },
      { "<leader>x", group = "Diagnostic" },
      { "<leader>h", group = "Hydra mode", mode = { "n", "v" } },
      { "<leader>mm", group = "Move around", mode = { "n", "v" } },
    }

    vim.keymap.set("n", "<leader>hw", function()
      require("which-key").show {
        keys = "<c-w>",
        loop = true, -- Continues until `<esc>` is pressed
      }
    end, { desc = "Resize current window" })
  end,
}
