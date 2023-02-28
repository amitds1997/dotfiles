local lualine_config = function ()
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
      lualine_b = { "filename", "branch" },
      lualine_c = { "diff", "diagnostics" },
      lualine_x = {},
      lualine_y = { "fileformat", "filetype", "progress" },
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
