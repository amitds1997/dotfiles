return {
  "echasnovski/mini.nvim",
  version = "*",
  event = "BufReadPost",
  config = function()
    -- Extend and create a/i textobjects
    require("mini.ai").setup()
    -- Move selected block using <Alt-h/j/k/l> key
    require("mini.move").setup()
    -- Add, delete, replace, find, highlight surrounding
    require("mini.surround").setup()
    -- Highlight patterns
    require("mini.hipatterns").setup()
    -- Indent markers
    require("mini.indentscope").setup({
      symbol = "│",
      options = { try_as_border = true },
      draw = { animation = require("mini.indentscope").gen_animation.none() },
    })
    -- Buffer remove handler
    require("mini.bufremove").setup()
    -- Restore cursor position
    require("mini.misc").setup_restore_cursor({
      center = true,
      ignore_filetype = require("core.vars").ignore_buftypes,
    })
    -- Mini file handler
    require("mini.files").setup()
  end,
}
