return function ()
  require("noice").setup({
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    cmdline = {
      format = {
        cmdline = { icon = " " },
        search_up = { icon = "?" },
        search_down = { icon = "/" },
        lua = false,
        help = false,
      },
    },
    messages = {
      view_search = "virtualtext",
    },
    routes = {
      {
        filter = {
          any = {
            { event = "msg_show", kind = "", find = "[w]" },
            { cmdline = "^:checkhealth" },
          },
        },
        view = "mini",
      },
      {
        view = "popup",
        filter = { event = "msg_show", kind = "", cmdline = true },
        opts = { replace = true, merge = true },
      },
    },
  })
end
