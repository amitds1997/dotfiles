local lsp_server_names = {
  bashls = "Bash LS",
  clangd = "Clang LS",
  dockerls = "Docker LS",
  eslint = "ESLint",
  gopls = "Go LS",
  jsonls = "JSON LS",
  lua_ls = "Lua LS",
  marksman = "Marksman",
  pyright = "Pyright",
  ruff_lsp = "Ruff LS",
  terraformls = "Terraform LS",
  tsserver = "Typescript LS",
  yamlls = "YAML LS",
}

local lualine_config = function()
  vim.o.laststatus = 3 -- Always show statusline
  local icons = require("nvim-nonicons")
  local devicons = require("nvim-web-devicons")
  local mode = {
    NORMAL = { icon = icons.get("vim-normal-mode") },
    INSERT = { icon = icons.get("vim-insert-mode") },
    VISUAL = { icon = icons.get("vim-visual-mode") },
    REPLACE = { icon = icons.get("vim-replace-mode") },
    COMMAND = { icon = icons.get("vim-command-mode") },
    ["V-LINE"] = { icon = icons.get("vim-visual-mode") },
  }
  local file_component = {
    "filename",
    symbols = {
      unnamed = "",
      modified = icons.get("pencil") .. " ",
      readonly = icons.get("lock"),
    },
  }

  local function get_lsp_clients()
    local file_icon = (
      icons.get(vim.bo.filetype)
      or devicons.get_icon_by_filetype(vim.bo.filetype)
      or devicons.get_icon(vim.fn.expand("%:e"))
      or devicons.get_default_icon()
    ) .. " "
    local lsp_label = ""

    local lsp_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #lsp_clients > 0 then
      local active_client = lsp_clients[1]
      lsp_label = file_icon .. " " .. (lsp_server_names[active_client.name] or active_client.name)
      if #lsp_clients > 1 then
        lsp_label = lsp_label .. ("(+%s)"):format(#lsp_clients - 1)
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
      lualine_a = {
        {
          "mode",
          fmt = function(mode_str)
            if mode[mode_str] ~= nil then
              return mode[mode_str].icon .. " "
            end
            return mode_str:sub(1, 1)
          end,
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
          require("noice").api.status.mode.get,
          cond = require("noice").api.status.mode.has,
          color = { bg = "NoiceCmdline" },
        },
      },
      lualine_y = { "location" },
      lualine_z = { get_lsp_clients },
    },
    inactive_sections = {
      lualine_c = {
        file_component,
      },
    },
    extensions = { "lazy", "nvim-tree", "quickfix", "trouble", "nvim-dap-ui" },
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
