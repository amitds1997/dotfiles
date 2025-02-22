return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require "nvim-autopairs"
    local Rule = require "nvim-autopairs.rule"
    local conds = require "nvim-autopairs.conds"

    npairs.setup {
      disable_filetype = require("settings").meta_filetypes,
      check_ts = true,
    }

    -- Handle "<>"
    npairs.add_rule(Rule("<", ">", {
      "-html",
      "-javascriptreact",
      "-typescriptreact",
    }):with_pair(conds.before_regex("%a+:?:?$", 3)):with_move(function(opts)
      return opts.char == ">"
    end))

    -- Move past commas and semicolons
    for _, punct in pairs { ",", ";" } do
      npairs.add_rules {
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
