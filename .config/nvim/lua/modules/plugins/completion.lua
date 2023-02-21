local package = require('core.pack').package

package({
  "hrsh7th/nvim-cmp",
  config = require("modules.configs.completion.cmp"),
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = require('modules.configs.completion.luasnip')
    },
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "lukas-reineke/cmp-under-comparator",
    "onsails/lspkind.nvim",
    "ray-x/cmp-treesitter",
    "saadparwaiz1/cmp_luasnip",
    {
      "windwp/nvim-autopairs",
      config = require("modules.configs.completion.nvim-autopairs")
    },
  }
})
