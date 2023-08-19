local window_names = {
  dapui_breakpoints = "DAP Breakpoints",
  dapui_scopes = "DAP Scopes",
  dapui_stacks = "DAP Stacks",
  dapui_watches = "DAP Watches",
  dapui_console = "DAP Console",
  [""] = "",
  ["TelescopePrompt"] = "",
}

local formatted_lsp_names = {
  lua_ls = "Lua",
  gopls = "Go",
  pyright = "Python",
  tsserver = "Typescript",
  bashls = "Bash",
  marksman = "Markdown",
  jsonls = "JSON",
  clangd = "Clangd",
  dockerls = "Docker",
  yamlls = "YAML",
  eslint = "ESLint",
}

local file_component = {
  "filename",
  symbols = {
    modified = "●",
    readonly = ""
  },
}

local lualine_config = function ()
  local devicons = require("nvim-web-devicons")

  local function get_lsp_clients()
    local file_icon = devicons.get_icon_by_filetype(vim.bo.filetype) .. " "
    local lsp_name = ""

    local lsp_clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(lsp_clients) do
      if client.name ~= "" then
        lsp_name = file_icon .. (formatted_lsp_names[client.name] or client.name) .. " LSP"
        if #lsp_clients > 1 then
          lsp_name = lsp_name .. (" (+%s)"):format(#lsp_clients - 1)
        end
        break
      else
        lsp_name = file_icon .. "Unknown LSP"
      end
    end


    return lsp_name
  end


  require("lualine").setup({
    options = {
      theme = "catppuccin",
      component_separators = "|",
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = vim.tbl_keys(window_names),
        winbar = { "dap-repl", "", "NvimTree", "checkhealth", "help", "man", "nofile", "notify", "prompt" },
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { "diagnostics" },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { get_lsp_clients },
    },
    winbar = {
      lualine_z = {
        file_component
      },
    },
    inactive_winbar = {
      lualine_x = {
        file_component
      },
    },
    extensions = { "lazy", "nvim-tree", "quickfix", "trouble" },
  })
end

return {
  "nvim-lualine/lualine.nvim",
  config = lualine_config,
  event = "VeryLazy",
}
