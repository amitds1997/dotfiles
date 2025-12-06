---@module 'lazy'
---@type LazyPluginSpec[]
return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- TODO: Set this up later on
      "ravitemer/mcphub.nvim",
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
          show_settings = true,
          start_in_insert_mode = true,
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
          opts = {
            completion_provider = "blink",
          },
        },
        inline = {
          keymaps = {
            accept_change = {
              modes = { n = "<leader>asa" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "<leader>asr" },
              description = "Reject the suggested change",
            },
          },
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
    },
    keys = {
      {
        "<leader>ac",
        function()
          vim.cmd "CodeCompanionChat"
        end,
        desc = "Open CodeCompanion Chat",
      },
      {
        "<leader>aa",
        function()
          vim.cmd "CodeCompanionActions"
        end,
        desc = "Open CodeCompanion Actions",
      },
    },
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   dependencies = {
  --     {
  --       "copilotlsp-nvim/copilot-lsp",
  --       init = function()
  --         vim.g.copilot_nes_debounce = 500
  --       end,
  --     },
  --   },
  --   opts = {
  --     suggestion = { enabled = false },
  --     panel = { enabled = false },
  --     nes = {
  --       enabled = true,
  --       keymap = {
  --         accept_and_goto = "<leader>an",
  --         accept = false,
  --         dismiss = "<Esc>",
  --       },
  --     },
  --     server_opts_overrides = {
  --       settings = {
  --         telemetry = {
  --           telemetryLevel = "off",
  --         },
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     require("copilot").setup(opts)
  --     vim.g.copilot_enabled = false
  --
  --     vim.api.nvim_create_autocmd("User", {
  --       pattern = "BlinkCmpMenuOpen",
  --       callback = function()
  --         vim.b.copilot_suggestion_hidden = false
  --       end,
  --     })
  --
  --     vim.api.nvim_create_autocmd("User", {
  --       pattern = "BlinkCmpMenuClose",
  --       callback = function()
  --         vim.b.copilot_suggestion_hidden = true
  --       end,
  --     })
  --   end,
  -- },
}
