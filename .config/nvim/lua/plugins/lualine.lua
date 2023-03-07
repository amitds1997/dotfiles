local lualine_config = function ()
  local devicons = require("nvim-web-devicons")

  local function get_lsp_clients()
    local file_icon = devicons.get_icon_by_filetype(vim.bo.filetype) .. " "
    local lsp_name = ""

    for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      if client.name ~= "" then
        lsp_name = file_icon .. client.name
      else
        lsp_name = file_icon .. "Unknown server"
      end
    end

    return lsp_name
  end

  require("lualine").setup({
    options = {
      theme = "catppuccin",
      component_separators = "|",
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = { "", "TelescopePrompt" },
      },
    },
    sections = {
      lualine_a = {
        { "mode", separator = { left = "" }, right_padding = 2 },
      },
      lualine_b = {
        {
          "filename",
          symbols = {
            modified = "●",
            readonly = ""
          },
        },
        "branch",
      },
      lualine_c = { "diff", "diagnostics" },
      lualine_x = {},
      lualine_y = { "fileformat", get_lsp_clients, "filetype", "progress" },
      lualine_z = {
        { "location", separator = { right = "" }, left_padding = 2 },
      },
    },
    tabline = {},
    extensions = {},
  })
end

return {
  "nvim-lualine/lualine.nvim",
  config = lualine_config,
  event = "VeryLazy",
}
