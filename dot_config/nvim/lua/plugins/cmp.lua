local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "󰠲",
  Interface = "󱦜",
  Module = "",
  Property = "󰓼",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "󰸌",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
}

local cmp_config = function ()
  local cmp, luasnip = require("cmp"), require("luasnip")

  local has_words_before = function ()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  -- Setup luasnip
  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup({
    enabled = function ()
      -- disable completion in comments
      local context = require("cmp.config.context")
      if context.in_treesitter_capture("context") or context.in_syntax_group("Comment") then
        return false
      else
        return true
      end
    end,
    snippet = {
      expand = function (args)
        luasnip.lsp_expand(args.body)
      end,
    },
    completion = {
      keyword_length = 2,
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function (entry, item)
        local menu = {
          nvim_lsp = "[LSP]",
          luasnip = "[Snip]",
          buffer = "[Buf]",
          path = "[Path]",
          cmdline_history = "[Cmd H]",
          cmdline = "[Cmd]",
        }

        if entry.source.name == "nvim_lsp" then
          item.menu = entry.source.source.client.name
        else
          item.menu = menu[entry.source.name] or entry.source.name
        end
        item.kind = string.format("%s %s", kind_icons[item.kind], item.kind)

        return item
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
      ["<Tab>"] = cmp.mapping(function (fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function (fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sorting = {
      priority_weight = 2,
      comparators = {
        cmp.config.compare.exact,
        cmp.config.compare.offset,
        cmp.config.compare.score,
        require("cmp-under-comparator").under,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    experimental = {
      ghost_text = {
        hl_group = "LspCodeLens",
      },
    },
    sources = cmp.config.sources({
      {
        name = "nvim_lsp",
        entry_filter = function (entry, _)
          return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
        end,
      },
      { name = "luasnip" },
      { name = "path" },
      { name = "treesitter" },
      {
        name = "buffer",
        option = {
          get_bufnrs = function ()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))

              if size > 1024 * 1024 then
                vim.notify(
                  "Current buffer exceeds set size limit: 1MB. Not indexing current buffer for completion"
                )
              else
                bufs[buf] = true
              end
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
    }),
  })

  -- Disable completion for certain filetypes
  cmp.setup.filetype("TelescopePrompt", {
    enabled = false,
  })

  -- Setup nvim autopairs
  require("nvim-autopairs").setup({
    check_ts = true,
  })

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return {
  "hrsh7th/nvim-cmp",
  config = cmp_config,
  enabled = function ()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
      or require("cmp_dap").is_dap_buffer()
  end,
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "lukas-reineke/cmp-under-comparator",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-path",
    "windwp/nvim-autopairs",
    "rcarriga/cmp-dap",
  },
}
