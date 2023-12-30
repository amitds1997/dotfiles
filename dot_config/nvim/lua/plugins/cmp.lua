local under_comparator = function(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find("^_+")
  local _, entry2_under = entry2.completion_item.label:find("^_+")
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

local cmp_config = function()
  local cmp, luasnip, lspkind, str = require("cmp"), require("luasnip"), require("lspkind"), require("cmp.utils.str")

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  -- Setup luasnip
  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup({
    enabled = function()
      -- disable completion in comments
      local context = require("cmp.config.context")
      if context.in_treesitter_capture("comment") or context.in_syntax_group("Comment") then
        return false
      end
      return true
    end,
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    completion = {
      keyword_length = 2,
    },
    formatting = {
      expandable_indicator = true,
      fields = { "kind", "abbr", "menu" },
      format = lspkind.cmp_format({
        mode = "symbol_text",
        preset = "codicons",
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        -- can also be a function to dynamically calculate max width such as
        -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
        ellipsis_char = "...",
        -- See [lspkind-nvim#30](https://github.com/onsails/lspkind-nvim/pull/30)
        before = function(entry, vim_item)
          local word = entry:get_insert_text()
          if entry.completion_item.snippet then
            word = vim.lsp.util.parse_snippet(word)
          end

          vim_item.abbr = str.oneline(word)
          return vim_item
        end,
      }),
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
      ["<CR>"] = cmp.mapping({
        i = function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          else
            fallback()
          end
        end,
        s = cmp.mapping.confirm({ select = true }),
        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      }),
      ["<Tab>"] = cmp.mapping(function(fallback)
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
      ["<S-Tab>"] = cmp.mapping(function(fallback)
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
        cmp.config.compare.offset,
        function(...) -- Locality bonus (distance-based sort)
          return require("cmp_buffer"):compare_locality(...)
        end,
        cmp.config.compare.exact,
        cmp.config.compare.score, -- Fuzzy search score (kind-of)
        cmp.config.compare.recently_used,
        cmp.config.compare.kind,
        cmp.config.compare.scopes,
        under_comparator,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    experimental = {
      ghost_text = {
        hl_group = "Comment",
      },
    },
    sources = cmp.config.sources({
      {
        name = "nvim_lsp",
        keyword_length = 0,
        priority = 100,
      },
      { name = "luasnip", option = { show_autosnippets = true }, priority = 130 },
      {
        name = "async_path",
        option = {
          trailing_slash = true,
        },
        priority = 70,
      },
    }, {
      {
        name = "buffer",
        max_item_count = 10,
        priority = 30,
        option = {
          get_bufnrs = function()
            local buf = vim.api.nvim_get_current_buf()
            local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
            if byte_size > 1024 * 1024 then -- 1 Megabyte max
              vim.notify("Current buffer exceeds set size limit: 1MB. Not indexing current buffer for auto-complete")
              return {}
            end
            return { buf }
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
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    "onsails/lspkind.nvim",
    "windwp/nvim-autopairs",
    "FelipeLema/cmp-async-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "rcarriga/cmp-dap",
    "saadparwaiz1/cmp_luasnip",
  },
}
