---@module 'lazy'
---@type LazyPluginSpec[]
return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ravitemer/mcphub.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      display = {
        action_palette = {
          provider = "snacks",
        },
        chat = {
          icons = {
            buffer_watch = " ",
            buffer_pin = "",
          },
          window = {
            border = "rounded",
            opts = {
              number = false,
              relativenumber = false,
            },
          },
          ---@param tokens string
          token_count = function(tokens, _)
            return string.format(" %s tokens ", tokens)
          end,
          show_settings = true,
          start_in_insert_mode = true,
          show_header_separator = true,
        },
      },
      strategies = {
        chat = {
          roles = {
            user = "User",
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
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function(_, opts)
      require("copilot").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })
    end,
  },
}
