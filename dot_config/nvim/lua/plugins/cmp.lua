local python_hidden_params_comparator = function(entry1, entry2)
  local e1_first_two = entry1.completion_item.label:sub(1, 2)
  local e2_first_two = entry2.completion_item.label:sub(1, 2)
  local e1_double_us = e1_first_two == "__"
  local e2_double_us = e2_first_two == "__"

  if e1_double_us ~= e2_double_us then
    return e2_double_us
  end

  local e1_single_us = e1_first_two[1] == "_"
  local e2_single_us = e2_first_two[1] == "_"

  if e1_single_us ~= e2_single_us then
    return e1_single_us
  end
end

local cmp_config = function()
  local MAX_ABBR_WIDTH, MAX_MENU_WIDTH = 25, 30
  local cmp, luasnip, constants = require("cmp"), require("luasnip"), require("core.constants")

  -- Setup luasnip
  require("luasnip.loaders.from_vscode").lazy_load()
  local snippets_dir = vim.fn.stdpath("config") .. "/snippets/"
  require("luasnip.loaders.from_lua").load({
    paths = { snippets_dir },
  })

  cmp.setup({
    enabled = function()
      local context = require("cmp.config.context")
      -- Disable completions in comment blocks unless they are documentation related
      return not (context.in_treesitter_capture("comment") or context.in_syntax_group("Comment"))
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
        local item_kind = constants.kind_icons[item.kind] or constants.kind_icons.Text
        item.kind = item_kind.icon
        item.kind_hl_group = item_kind.hl or item.kind_hl_group

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
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
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
      ["<c-h>"] = cmp.mapping(function()
        if luasnip.choice_active() then
          luasnip.change_choice(-1)
        end
      end),
      ["<c-l>"] = cmp.mapping(function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end),
    }),
    sorting = {
      priority_weight = 2,
      comparators = {
        require("copilot_cmp.comparators").prioritize,
        cmp.config.compare.exact,
        cmp.config.compare.recently_used,
        cmp.config.compare.offset,
        function(...) -- Locality bonus (distance-based sort)
          return require("cmp_buffer"):compare_locality(...)
        end,
        cmp.config.compare.scopes,
        python_hidden_params_comparator,
        cmp.config.compare.kind,
        cmp.config.compare.score, -- Fuzzy search score (kind-of)
        cmp.config.compare.length,
        cmp.config.compare.order,
        cmp.config.compare.sort_text,
      },
    },
    experimental = {
      ghost_text = {
        hl_group = "CmpGhostText",
      },
    },
    sources = cmp.config.sources({
      { name = "copilot", priority = 190 },
      { name = "luasnip", option = { show_autosnippets = true }, priority = 150, max_item_count = 3 },
      {
        name = "nvim_lsp",
        keyword_length = 0,
        priority = 100,
      },
      {
        name = "async_path",
        option = {
          trailing_slash = false,
          label_trailing_slash = true,
          show_hidden_files_by_default = true,
        },
      },
    }, {
      {
        name = "buffer",
        priority = 30,
        option = {
          get_bufnrs = function()
            local buf = vim.api.nvim_get_current_buf()
            local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
            if byte_size > require("core.vars").max_filesize then
              vim.notify("Current buffer exceeds set size limit: 1MB. Not indexing current buffer for auto-complete")
              return {}
            end
            return { buf }
          end,
        },
      },
    }),
  })

  -- Completions on cmdline
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "async_path" },
    }, {
      {
        name = "cmdline",
        options = {
          ignore_cmds = { "Man", "!" },
        },
      },
    }),
  })

  -- Disable completion for certain filetypes
  cmp.setup.filetype("TelescopePrompt", {
    enabled = false,
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
  event = { "InsertEnter", "CmdlineEnter" },
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
        require("nvim-autopairs").setup({
          disable_filetype = require("core.vars").temp_filetypes,
          check_ts = true,
        })

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
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "https://codeberg.org/FelipeLema/cmp-async-path",
    "zbirenbaum/copilot-cmp",
  },
}
