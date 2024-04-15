local lsp_server_names = {
  bashls = { name = "Bash LS", priority = 20 },
  clangd = { name = "Clang LS", priority = 20 },
  dockerls = { name = "Docker LS", priority = 20 },
  eslint = { name = "ESLint", priority = 15 },
  gopls = { name = "Go LS", priority = 20 },
  jsonls = { name = "JSON LS", priority = 20 },
  lua_ls = { name = "Lua LS", priority = 20 },
  marksman = { name = "Marksman", priority = 20 },
  basedpyright = { name = "Python LS", priority = 20 },
  ruff_lsp = { name = "Ruff LS", priority = 15 },
  terraformls = { name = "Terraform LS", priority = 20 },
  tsserver = { name = "Typescript LS", priority = 20 },
  yamlls = { name = "YAML LS", priority = 20 },
  cssls = { name = "CSS LS", priority = 20 },
}

local lualine_config = function()
  vim.o.laststatus = 3 -- Always show statusline

  local icons = require("nvim-nonicons")
  local devicons = require("nvim-web-devicons")
  local file_component = {
    "filename",
    symbols = {
      unnamed = "",
      modified = icons.get("dot-fill"),
      readonly = icons.get("lock"),
    },
  }

  local function get_lsp_clients()
    local file_icon, _ = devicons.get_icon(vim.fn.expand("%:e"), vim.bo.filetype, { default = true })
    local lsp_label = ""

    local assorted = {}
    for _, lsp in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      table.insert(assorted, lsp_server_names[lsp.name] or { name = lsp.name, priority = 15 })
    end
    table.sort(assorted, function(x, y)
      return x.priority >= y.priority
    end)

    if #assorted > 0 then
      local active_client = assorted[1]
      lsp_label = file_icon .. " " .. (lsp_server_names[active_client.name] or active_client.name)
      if #assorted > 1 then
        lsp_label = lsp_label .. ("(+%s)"):format(#assorted - 1)
      end
    end

    return lsp_label
  end

  require("lualine").setup({
    options = {
      theme = require("core.vars").statusline_colorscheme,
      component_separators = "┃",
      section_separators = "",
      disabled_filetypes = require("core.vars").ignore_buftypes,
    },
    sections = {
      lualine_a = {
        {
          "mode",
          icons_enabled = true,
          separator = { left = "" },
          padding = { right = 1 },
        },
      },
      lualine_b = {
        file_component,
        {
          "branch",
          icon = icons.get("git-branch"),
        },
      },
      lualine_c = {
        {
          "diagnostics",
          sources = {
            "nvim_lsp",
            "nvim_diagnostic",
          },
        },
      },
      lualine_x = {
        {
          require("noice").api.status.mode.get_hl,
          cond = require("noice").api.status.mode.has,
        },
        "selectioncount",
      },
      lualine_y = {
        "location",
      },
      lualine_z = {
        {
          get_lsp_clients,
        },
        {
          require("plugins.lualine-components.venv").current_venv,
        },
        {
          "progress",
          separator = { right = "" },
          padding = { left = 1 },
        },
      },
    },
    inactive_sections = {
      lualine_c = {
        file_component,
      },
    },
    extensions = { "lazy", "quickfix", "nvim-dap-ui" },
  })
end

return {
  "nvim-lualine/lualine.nvim",
  config = lualine_config,
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
}
