local constants = require("core.constants")

local function nvim_notify_setup()
  ---@diagnostic disable-next-line:missing-fields
  require("notify").setup({
    background_colour = "#000000",
    icons = {
      ERROR = constants.severity_icons[vim.diagnostic.severity.ERROR],
      WARN = constants.severity_icons[vim.diagnostic.severity.WARN],
      INFO = constants.severity_icons[vim.diagnostic.severity.INFO],
      HINT = constants.severity_icons[vim.diagnostic.severity.HINT],
    },
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
      },
    },
    popupmenu = {
      enabled = true,
      ---@type 'nui'|'cmp'
      backend = "cmp",
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      progress = {
        enabled = false,
      },
    },
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    views = {
      notify = {
        replace = true,
      },
      mini = {
        timeout = 3000,
        zindex = 70,
        size = { height = "auto", width = "auto", max_height = 5 },
        format = { "{title} ", "{message}" },
        win_options = {
          winblend = 0,
        },
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
          any = {
            { find = "^[/?]." }, -- Do not show search pattern if not found
          },
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B written" }, -- written to file
            { find = "; after #%d+" }, -- Redo
            { find = "; before #%d+" }, -- Undo
            { find = "^E486: Pattern not found" }, -- Search not found
            { find = "Hunk %d+ of %d+" }, -- Git signs
            { find = "%d+ lines <ed %d+ time" }, -- <ed content
            { find = "%d+ lines >ed %d+ time" }, -- >ed content
            { find = "%d+ substitutions on %d+ lines" }, -- Substitutions done
            { find = "%d+ fewer lines" }, -- Multiple lines deleted
            { find = "%d+ more lines" }, -- Multiple lines pasted
            { find = "%d+ lines yanked" }, -- Multiple lines yanked
            { find = "%d+ lines changed" }, -- Multiple lines changed
          },
        },
        opts = {
          timeout = 1000,
        },
        view = "mini",
      },
      {
        filter = {
          event = "notify",
          kind = { "debug", "trace" }, -- Debug and trace notifications
        },
        opts = {
          timeout = 5000,
        },
        view = "mini",
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
