local constants = require("core.constants")

local function lspsaga_config()
  require("lspsaga").setup({
    symbol_in_winbar = {
      hide_keyword = true,
      folder_level = 0,
    },
    code_action = {
      extend_gitsigns = true,
      show_server_name = true,
    },
    diagnostic = {
      extend_relatedInformation = true,
    },
    finder = {
      default = "dec+def+imp+ref",
      methods = {
        ["dec"] = "textDocument/declaration",
      },
    },
    lightbulb = {
      enable = false,
    },
    outline = {
      win_position = "right",
    },
    ui = {
      expand = " ",
      collapse = " ",
      lines = { "╰", "├", "│", "─", "╭" },
      border = constants.border_styles.rounded,
    },
  })
end

return {
  "nvimdev/lspsaga.nvim",
  config = lspsaga_config,
  event = "LspAttach",
  cmd = "Lspsaga",
}
