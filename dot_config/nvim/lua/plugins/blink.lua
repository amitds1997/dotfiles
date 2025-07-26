local kind_icons = require("constants").kind_icons

return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "1.*",
  dependencies = {
    {
      "giuxtaposition/blink-cmp-copilot",
    },
    {
      -- Improves the rendered completion menu using treesitter
      "xzbdmw/colorful-menu.nvim",
      config = true,
    },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is detected
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  opts = {
    keymap = {
      preset = "default",
    },
    completion = {
      ghost_text = {
        enabled = true,
      },
      list = {
        selection = { preselect = false, auto_insert = true },
        max_items = 10,
      },
      menu = {
        border = "rounded",
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
        end,
        draw = {
          columns = { { "kind_icon" }, { "label", gap = 1 } },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                else
                  icon = kind_icons[ctx.kind] or kind_icons.Text
                end

                return icon .. ctx.icon_gap
              end,

              -- Optionally, use the highlight groups from nvim-web-devicons
              -- You can also add the same function for `kind.highlight` if you want to
              -- keep the highlight groups in sync with the icons.
              highlight = function(ctx)
                local hl = "BlinkCmpKind" .. ctx.kind
                  or require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        window = { border = "rounded" },
      },
    },
    signature = { enabled = true, window = { border = "rounded" } },
    cmdline = { enabled = true },
    sources = {
      min_keyword_length = function(ctx)
        -- Only applies when typing a command, doesn't apply to arguments
        if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
          return 2
        end
        return 0
      end,
      default = function()
        local sources = { "lazydev", "lsp", "buffer" }
        local success, node = pcall(vim.treesitter.get_node)

        if success and node then
          if not vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            table.insert(sources, "path")
          else
            return { "buffer" }
          end
          if node:type() ~= "string" then
            table.insert(sources, "snippets")
          end

          table.insert(sources, "copilot")
        end

        return sources
      end,
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- Make lazydev completions top priority
          score_offset = 100,
        },
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          -- Another top priority so that it shows up on top
          score_offset = 100,
          async = true,
        },
        cmdline = {
          -- Ignore cmdline completion when executing shell commands
          enabled = function()
            return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match "^[%%0-9,'<>%-]*!"
          end,
        },
        buffer = {
          opts = {
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                return vim.bo[bufnr].buftype == ""
              end, vim.api.nvim_list_bufs())
            end,
          },
        },
      },
    },
  },
}
