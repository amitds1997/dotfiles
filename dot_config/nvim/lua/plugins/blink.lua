---@module 'lazy'
---@type LazyPluginSpec
return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  branch = "main",
  build = "cargo build --release",
  dependencies = {
    "xzbdmw/colorful-menu.nvim",
    {
      "folke/lazydev.nvim",
      ft = "lua",
      config = function(_, opts)
        require("lazydev").setup(opts)
        vim.lsp.config("lua_ls", {
          root_dir = function(bufnr, on_dir)
            on_dir(require("lazydev").find_workspace(bufnr))
          end,
        })
      end,
    },
    {
      "copilotlsp-nvim/copilot-lsp",
      init = function()
        vim.g.copilot_nes_debounce = 500
        vim.keymap.set("n", "<tab>", function()
          local bufnr = vim.api.nvim_get_current_buf()
          local state = vim.b[bufnr].nes_state
          if vim.lsp.is_enabled "copilot_ls" and state then
            -- Try to jump to the start of the suggestion edit
            -- If already at the start, then apply the pending suggestion
            -- and jump to the end of the edit
            local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
              or (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())

            return nil
          else
            -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
            return "<Tab>"
          end
        end, { desc = "Accept Copilot NES suggestion", expr = true })
      end,
    },
  },
  ---@type blink.cmp.Config
  opts = {
    enabled = function()
      return not vim.tbl_contains({ "bigfile" }, vim.bo.filetype)
    end,
    cmdline = {
      keymap = { preset = "cmdline" },
      completion = {
        list = { selection = { preselect = false } },
        menu = {
          auto_show = function()
            return vim.fn.getcmdtype() == ":"
          end,
        },
      },
    },
    keymap = {
      preset = "default",
      ["<Tab>"] = {
        "snippet_forward",
        function()
          return vim.lsp.is_enabled "copilot_ls"
            and (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())
        end,
        "fallback",
      },
    },
    completion = {
      ghost_text = {
        enabled = false,
      },
      menu = {
        scrollbar = false,
        draw = {
          -- treesitter = { "lsp" },
          columns = { { "kind_icon" }, { "label", gap = 1 } },
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                else
                  icon = require("core.constants").kind_icons[ctx.kind]
                end
                return icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
        direction_priority = { "n", "s" },
      },
      list = {
        selection = { preselect = false, auto_insert = true },
        max_items = 50,
      },
      documentation = { auto_show = true, window = { scrollbar = false } },
    },
    signature = { enabled = true, window = { winblend = 0, scrollbar = false } },
    appearance = {
      nerd_font_variant = "mono",
      kind_icons = require("core.constants").kind_icons,
    },
    sources = {
      min_keyword_length = function(ctx)
        -- Only applies when typing a command, doesn't apply to arguments
        if (ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil) or vim.bo.filetype == "markdown" then
          return 1
        end
        return 0
      end,
      default = { "lsp", "buffer", "snippets", "path" },
      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
  },
  config = function(_, opts)
    require("blink.cmp").setup(opts)

    -- TODO: Keep track of this for dynamicRegistration https://github.com/neovim/neovim/pull/35578
    local extraCapabilities = {
      textDocument = {
        onTypeFormatting = {
          dynamicRegistration = false,
        },
      },
    }

    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(extraCapabilities, true),
    })
  end,
}
