return function ()
  local cmp, luasnip, lspkind = require("cmp"), require("luasnip"), require("lspkind")

  local has_words_before = function ()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local compare = require("cmp.config.compare")
  compare.lsp_scores = function (entry1, entry2)
    local diff
    if entry1.completion_item.score and entry2.completion_item.score then
      diff = (entry2.completion_item.score * entry2.score) - (entry1.completion_item.score * entry1.score)
    else
      diff = entry2.score - entry1.score
    end
    return (diff < 0)
  end

  cmp.setup({
    snippet = {
      expand = function (args)
        luasnip.lsp_expand(args.body)
      end,
    },
    completion = {
      keyword_length = 2,
    },
    preselect = cmp.PreselectMode.Item,
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = lspkind.cmp_format({
        mode = "symbol_text",
        menu = {
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          buffer = "[Buffer]"
        }
      }),
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs( -4)),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
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
        elseif luasnip.jumpable( -1) then
          luasnip.jump( -1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sorting = {
      priority_weight = 2,
      comparators = {
        compare.offset,
        compare.exact,
        compare.lsp_scores,
        require("cmp-under-comparator").under,
        compare.kind,
        compare.sort_text,
        compare.length,
        compare.order,
      }
    },
    experimental = {
      ghost_text = {
        hl_group = "LspCodeLens",
      }
    },
    sources = cmp.config.sources({
      {
        name = "nvim_lsp",
        entry_filter = function (entry, _)
          return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
        end
      },
      { name = "luasnip" },
    },
      { name = "luasnip" },
      { name = "path" },
      { name = "treesitter" },
      {
        {
          name = "buffer",
          option = {
            get_bufnrs = function ()
              local buf = vim.api.nvim_get_current_buf()
              local size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
              if size > 1024 * 1024 then
                vim.notify(
                  "Current buffer exceeds set size limit: 1MB. Not indexing current buffer for completion")
                return {}
              end
              return { buf }
            end
          }
        },
      }),
  })

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done()
  )
end
