local constants = require("core.constants")
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
  local MAX_ABBR_WIDTH, MAX_MENU_WIDTH = 25, 30
  local cmp, luasnip = require("cmp"), require("luasnip")

  -- Setup luasnip
  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup({
    enabled = function()
      local context = require("cmp.config.context")
      -- Disable completions in comment blocks
      return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
    end,
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    formatting = {
      expandable_indicator = true,
      fields = { "kind", "abbr", "menu" },
      format = function(entry, item)
        item.menu = entry:get_completion_item().detail or item.kind
        item.kind = (constants.kind_icons[item.kind] or constants.kind_icons.Text)

        -- Useful for debugging bogus completions
        --
        -- if entry.source.name == "nvim_lsp" then
        --   local client_name = entry.source.source.client.name
        --   item.menu = vim.tbl_get(constants.lsps[client_name], "name") or client_name
        -- else
        --   item.menu = ({
        --     luasnip = "Snippet",
        --     async_path = "Path",
        --     buffer = "Buffer",
        --   })[entry.source.name]
        -- end

        if vim.api.nvim_strwidth(item.abbr) > MAX_ABBR_WIDTH then
          item.abbr = vim.fn.strcharpart(item.abbr, 0, MAX_ABBR_WIDTH) .. constants.icons.Ellipsis
        end

        if vim.api.nvim_strwidth(item.menu) > MAX_MENU_WIDTH then
          item.menu = vim.fn.strcharpart(item.menu, 0, MAX_MENU_WIDTH) .. constants.icons.Ellipsis
        end

        return item
      end,
    },
    preselect = cmp.PreselectMode.None,
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
      ["<C-p>"] = cmp.mapping.select_prev_item({
        behavior = cmp.SelectBehavior.Insert,
      }),
      ["<C-n>"] = cmp.mapping.select_next_item({
        behavior = cmp.SelectBehavior.Insert,
      }),
      ["<C-y>"] = cmp.mapping(
        cmp.mapping.confirm({
          behavior = cmp.SelectBehavior.Insert,
          select = true,
        }),
        { "i", "c" }
      ),
      ["<c-j>"] = cmp.mapping(function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { "i", "s" }),
      ["<c-k>"] = cmp.mapping(function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
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
        priority = 150,
      },
      { name = "luasnip", option = { show_autosnippets = true }, priority = 50, max_item_count = 3 },
      {
        name = "async_path",
        option = {
          trailing_slash = false,
          label_trailing_slash = true,
          show_hidden_files_by_default = true,
        },
      },
      {
        name = "buffer",
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
    return vim.api.nvim_get_option_value("buftype", {
      buf = 0,
    }) ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
  event = { "InsertEnter" },
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup()

        for _, punc in pairs({ ",", ";" }) do
          require("nvim-autopairs").add_rules({
            require("nvim-autopairs.rule")("", punc)
              :with_move(function(opts)
                return opts.char == punc
              end)
              :with_pair(function()
                return false
              end)
              :with_del(function()
                return false
              end)
              :with_cr(function()
                return false
              end)
              :use_key(punc),
          })
        end
      end,
    },
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "rcarriga/cmp-dap",
    "saadparwaiz1/cmp_luasnip",
    {
      "https://codeberg.org/FelipeLema/cmp-async-path",
    },
    "yamatsum/nvim-nonicons",
  },
}
