local file_component = {
  "filename",
  symbols = {
    modified = "●",
    readonly = "",
  },
}

local lsp_server_names = {
  bashls = "Bash",
  clangd = "C++",
  dockerls = "Docker",
  eslint = "ESLint",
  gopls = "Go",
  jsonls = "JSON",
  lua_ls = "Lua",
  marksman = "Markdown",
  pylsp = "Python",
  terraformls = "Terraform",
  tsserver = "TS",
  yamlls = "YAML",
}

local macro = function()
  local macro_register = vim.fn.reg_recording()
  if macro_register ~= "" then
    return ("Recording macro: @%s"):format(macro_register)
  end
  return macro_register
end

local lualine_config = function()
  local devicons = require("nvim-web-devicons")

  local function get_lsp_clients()
    local file_icon = (
      devicons.get_icon_by_filetype(vim.bo.filetype)
      or devicons.get_icon(vim.fn.expand("%:e"))
      or devicons.get_default_icon()
    ) .. " "
    local lsp_label = ""

    local lsp_clients = vim.lsp.get_active_clients({ bufnr = 0 })
    if #lsp_clients > 0 then
      local active_client = lsp_clients[1]
      lsp_label = file_icon .. (lsp_server_names[active_client.name] or active_client.name) .. " LSP"
      if #lsp_clients > 1 then
        lsp_label = lsp_label .. (" (+ %s)"):format(#lsp_clients - 1)
      end
    end

    return lsp_label
  end

  require("lualine").setup({
    options = {
      theme = require("core.vars").colorscheme,
      component_separators = "|",
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { file_component },
      lualine_c = { "branch", "diffmode", "diagnostics" },
      lualine_x = {},
      lualine_y = { macro, "progress" },
      lualine_z = { get_lsp_clients },
    },
    extensions = { "lazy", "nvim-tree", "quickfix", "trouble", "nvim-dap-ui", "mason" },
  })
end

return {
  "nvim-lualine/lualine.nvim",
  config = lualine_config,
  event = "ColorScheme",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
}
