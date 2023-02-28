local nvim_cokeline_config = function ()
  local get_hex = require("cokeline.utils").get_hex
  local is_picking_focus = require("cokeline/mappings").is_picking_focus
  local is_picking_close = require("cokeline/mappings").is_picking_close

  local in_focus_color = get_hex("Winbar", "fg")
  local not_in_focus_color = get_hex("Normal", "bg")

  local components = {
    status_icon = {
      text = function (buffer)
        return buffer.is_modified and "●" or ""
      end,
      delete_buffer_on_left_click = true,
      truncation = { priority = 1 }
    },
    unique_prefix = {
      text = function (buffer)
        return buffer.unique_prefix
      end,
      style = "italic",
      fg = get_hex("Comment", "fg"),
      truncation = {
        priority = 3,
        direction = "left",
      },
    },
    file_icon = {
      text = function (buffer)
        return (is_picking_focus() or is_picking_close()) and buffer.pick_letter .. " " or buffer.devicon.icon
      end,
      fg = function (buffer)
        return buffer.is_focused and not_in_focus_color or in_focus_color
      end,
      truncation = { priority = 1 }
    },
    file_name = {
      text = function (buffer) return buffer.filename .. " " end,
      truncation = {
        priority = 2,
        direction = "left",
      },
    },
    white_space = {
      text = " ",
      truncation = { priority = 1 }
    },
    left_separator = {
      text = function (buffer) return (buffer.is_focused or buffer.is_first) and "" or " " end,
      fg = function (buffer) return buffer.is_focused and in_focus_color or not_in_focus_color end,
      bg = function (buffer) return buffer.is_first and get_hex("ColorColumn", "fg") or not_in_focus_color end,
      truncation = { priority = 1 }
    },
    right_separator = {
      text = function (buffer) return (buffer.is_focused or buffer.is_last) and "" or " " end,
      fg = function (buffer) return buffer.is_focused and in_focus_color or not_in_focus_color end,
      bg = function (buffer) return buffer.is_last and get_hex("ColorColumn", "fg") or not_in_focus_color end,
      truncation = { priority = 1 }
    }
  }

  require("cokeline").setup({
    buffers = {
      filter_valid = function (buffer) return buffer.filename ~= "[No Name]" end,
    },
    rendering = {
      max_buffer_width = 30,
    },
    default_hl = {
      bg = function (buffer)
        if buffer.is_focused then
          return in_focus_color
        end
        return not_in_focus_color
      end,
    },
    sidebar = {
      filetype = "NvimTree",
      components = {
        {
          text = "",
          fg = get_hex("NvimTreeNormal", "fg"),
          bg = get_hex("NvimTreeNormal", "bg"),
        }
      }
    },
    components = {
      components.left_separator,
      components.file_icon,
      components.unique_prefix,
      components.file_name,
      components.status_icon,
      components.right_separator,
    },
  })

  vim.keymap.set('n', '<Tab>', '<Plug>(cokeline-focus-next)', {silent = true, desc = "Jump to next buffer"})
  vim.keymap.set('n', '<S-Tab>', '<Plug>(cokeline-focus-prev)', {silent = true, desc = "Jump to previous buffer"})
end
return  {
    "noib3/nvim-cokeline",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = nvim_cokeline_config,
    event = { "BufReadPre", "BufAdd", "BufNewFile" },
  }
