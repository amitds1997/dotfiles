---@module 'lazy'
---@type LazyPluginSpec[]
return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      display = {
        action_palette = {
          provider = "mini_pick",
        },
        chat = {
          icons = {
            buffer_watch = " ",
            buffer_pin = "",
          },
          show_reasoning = true,
          fold_reasoning = true,
          window = {
            border = "rounded",
            opts = {
              number = false,
              relativenumber = false,
            },
            sticky = true,
          },
          ---@param tokens string
          token_count = function(tokens, _)
            return string.format(" %s tokens ", tokens)
          end,
          -- show_settings = true,
          start_in_insert_mode = false,
          show_header_separator = true,
        },
        diff = {
          enabled = true,
        },
      },
      adapters = {
        acp = {
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              defaults = {
                auth_method = "oauth-personal",
              },
            })
          end,
        },
      },
      strategies = {
        chat = {
          roles = {
            user = "Me",
          },
          slash_commands = {
            ["buffer"] = {
              keymaps = {
                modes = {
                  i = "<C-b>",
                  n = { "<C-b>", "gb" },
                },
              },
            },
          },
          adapter = {
            name = "copilot",
            model = "gpt-5.1",
          },
          opts = {
            completion_provider = "blink",
          },
        },
        inline = {
          keymaps = {
            accept_change = {
              modes = { n = "ga" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "gr" },
              description = "Reject the suggested change",
            },
            stop = {
              modes = { n = "q" },
              description = "Stop the current action",
            },
          },
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4.5",
          },
        },
      },
      ignore_warnings = true,
    },
    keys = {
      {
        "<leader>ac",
        function()
          vim.cmd "CodeCompanionChat"
        end,
        desc = "Open CodeCompanion Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>aa",
        function()
          vim.cmd "CodeCompanionActions"
        end,
        desc = "Open CodeCompanion Actions",
      },
      {
        "<leader>at",
        function()
          vim.cmd "CodeCompanionChat Toggle"
        end,
        desc = "Toggle the CodeCompanion Chat window",
      },
    },
  },
}
