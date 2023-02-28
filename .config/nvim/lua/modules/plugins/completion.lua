local package = require('core.lazy').package

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
    "lukas-reineke/cmp-under-comparator",
    "saadparwaiz1/cmp_luasnip",
    {
      "windwp/nvim-autopairs",
      config = require("modules.configs.completion.nvim-autopairs")
    },
  }
})
