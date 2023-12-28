return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        background_colour = "#000000",
      },
    },
  },
  opts = {
    cmdline = {
      format = {
        IncRename = {
          pattern = "^:%s*IncRename%s+",
          title = "Rename",
          conceal = true,
          opts = {
            relative = "cursor",
            size = { min_width = 30 },
            position = { row = -2, col = 0 },
          },
        },
      },
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    routes = {
      -- Show written messages as mini notification
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "[w]",
        },
        view = "mini",
      },
    },
  },
}
