local null_ls_config = function ()
  local null_ls = require("null-ls")

  null_ls.setup({
    sources = {
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.beautysh,
      null_ls.builtins.formatting.codespell,
      null_ls.builtins.formatting.jq
    }
  })
end

return {
  "jose-elias-alvarez/null-ls.nvim",
  config = null_ls_config,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
