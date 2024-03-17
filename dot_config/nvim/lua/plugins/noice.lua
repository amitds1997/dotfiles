local constants = require("core.constants")

local function nvim_notify_setup()
  require("notify").setup({
    background_colour = "#000000",
  })
end

local function noice_setup()
  local nonicons = require("nvim-nonicons")

  require("noice").setup({
    cmdline = {
      format = {
        cmdline = { icon = nonicons.get("chevron-right") .. " " },
        search_down = { icon = nonicons.get("chevron-down") .. " " },
        search_up = { icon = nonicons.get("chevron-up") .. " " },
        filter = { icon = nonicons.get("terminal") .. " ", title = " Shell " },
        lua = { icon = nonicons.get("lua") .. " " },
        help = { icon = nonicons.get("question") .. " " },
        IncRename = {
          pattern = "^:%s*IncRename%s+",
          title = " Rename ",
          conceal = true,
          icon = nonicons.get("sync"),
          opts = {
            relative = "cursor",
            size = { min_width = 30 },
            position = { row = -2, col = 0 },
          },
        },
      },
    },
    popupmenu = {
      enabled = true,
      ---@type 'nui'|'cmp'
      backend = "nui",
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
    views = {
      mini = {
        size = { height = "auto", width = "auto", max_height = 5 },
      },
      cmdline_popup = {
        border = {
          padding = { 0, 1 },
          style = constants.border_styles.rounded,
        },
        filter_options = {},
        win_options = {
          winhighlight = {
            NormalFloat = "NormalFloat",
            FloatTitle = "TelescopePromptTitle",
            FloatBorder = "TelescopePromptBorder",
          },
        },
      },
    },
    routes = {
      -- Hide buffer written messages
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "[w]",
        },
        opts = { skip = true },
      },
    },
  })
end

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      config = nvim_notify_setup,
    },
  },
  config = noice_setup,
}
