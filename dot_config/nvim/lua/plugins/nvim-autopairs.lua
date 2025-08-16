---@module 'lazy'
---@type LazyPluginSpec
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local nvim_pairs = require "nvim-autopairs"
    local Rule = require "nvim-autopairs.rule"
    local conds = require "nvim-autopairs.conds"

    local disabled_filetypes = vim.deepcopy(require("settings").meta_filetypes)
    table.insert(disabled_filetypes, "markdown")

    nvim_pairs.setup {
      disable_filetype = disabled_filetypes,
      check_ts = true,
    }

    -- Handle "<>"
    nvim_pairs.add_rule(Rule("<", ">", {
      "-html",
      "-javascriptreact",
      "-typescriptreact",
    }):with_pair(conds.before_regex("%a+:?:?$", 3)):with_move(function(opts)
      return opts.char == ">"
    end))

    -- Move past commas and semicolons
    for _, punct in pairs { ",", ";" } do
      nvim_pairs.add_rules {
        Rule("", punct)
          :with_move(function(opts)
            return opts.char == punct
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
          :use_key(punct),
      }
    end
  end,
}
