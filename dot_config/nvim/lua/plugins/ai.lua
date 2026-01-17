---@module 'lazy'
---@type LazyPluginSpec[]
return {
  {
    "folke/sidekick.nvim",
    lazy = false,
    opts = {
      cli = {
        mux = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select()
        end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send { msg = "{this}" }
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send { msg = "{file}" }
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send { msg = "{selection}" }
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle { name = "claude", focus = true }
        end,
        desc = "Sidekick Toggle Claude",
      },
    },
  },
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
        },
        adapter = {
          name = "copilot",
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
        },
      },
    },
    ignore_warnings = true,
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
