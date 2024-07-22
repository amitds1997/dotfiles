local constants = require("core.constants")

local function space_handler(cond)
  return {
    function()
      return " "
    end,
    cond = cond,
    color = "lualine_a_inactive",
  }
end

local lualine_config = function()
  vim.o.laststatus = 3 -- Always show statusline

  local icons = require("nvim-nonicons")
  local devicons = require("nvim-web-devicons")
  local file_component = {
    "filename",
    padding = { right = 0, left = 1 },
    separator = { left = "", right = "" },
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
      table.insert(assorted, constants.lsps[lsp.name] or { name = lsp.name, priority = 15 })
    end
    assorted = vim.tbl_filter(function(lsp_record)
      return lsp_record.name ~= "copilot"
    end, assorted)
    table.sort(assorted, function(x, y)
      return x.priority >= y.priority
    end)

    if #assorted > 0 then
      local active_client = assorted[1]
      lsp_label = file_icon .. "  " .. (constants.lsps[active_client.name] or active_client.name)
      if #assorted > 1 then
        lsp_label = lsp_label .. ("(+%s)"):format(#assorted - 1)
      end
    end

    if vim.bo.filetype == "python" then
      lsp_label = lsp_label .. require("plugins.lualine-components.venv").current_env()
    end

    return lsp_label
  end

  local color_scheme = require("core.vars").colorscheme
  ---@type string|table
  local theme_name = color_scheme
  if color_scheme == "neofusion" then
    theme_name = require("neofusion.lualine")
  elseif color_scheme == "material" then
    theme_name = "material-stealth"
  end

  require("lualine").setup({
    options = {
      theme = theme_name,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = require("core.vars").temp_buf_filetypes,
    },
    sections = {
      lualine_a = {
        {
          "mode",
          icons_enabled = true,
          icon = constants.icons.NeovimIcon,
          padding = { right = 0, left = 0 },
          separator = { left = "", right = "" },
        },
      },
      lualine_b = {
        file_component,
        space_handler(function()
          return require("lualine.components.branch.git_branch").get_branch() ~= ""
        end),
        {
          "branch",
          icon = constants.icons.GitBranch,
          padding = { right = 0, left = 0 },
          separator = { left = "", right = "" },
        },
        space_handler(function()
          return vim.g.remote_neovim_host or false
        end),
        {
          function()
            return vim.g.remote_neovim_host and ("Remote: %s"):format(vim.uv.os_gethostname()) or ""
          end,
          padding = { right = 1, left = 1 },
          separator = { left = "", right = "" },
        },
      },
      lualine_c = {
        {
          "diagnostics",
          sources = {
            "nvim_diagnostic",
          },
          symbols = {
            error = constants.severity_icons[vim.diagnostic.severity.ERROR],
            warn = constants.severity_icons[vim.diagnostic.severity.WARN],
            info = constants.severity_icons[vim.diagnostic.severity.INFO],
            hint = constants.severity_icons[vim.diagnostic.severity.HINT],
          },
        },
      },
      lualine_x = {
        {
          require("noice").api.status.mode.get_hl,
          cond = require("noice").api.status.mode.has,
        },
        {
          require("noice").api.status.search.get_hl,
          cond = require("noice").api.status.search.has,
        },
        "selectioncount",
      },
      lualine_y = {
        {
          get_lsp_clients,
          padding = { left = 0, right = 0 },
          separator = { left = "", right = "" },
          on_click = function()
            vim.cmd("LspInfo")
          end,
        },
        space_handler(function()
          return #vim.lsp.get_clients({ bufnr = 0 }) > 0
        end),
        {
          "copilot",
          cond = function()
            if not package.loaded["copilot"] then
              return
            end
            local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
            if not ok then
              return false
            end
            return ok and #clients > 0
          end,
          padding = { left = 0, right = 1 },
          separator = { left = "", right = "" },
          symbols = {
            status = {
              icons = {
                enabled = " ",
                sleep = " ", -- auto-trigger disabled
                disabled = " ",
                warning = " ",
                unknown = "",
              },
            },
            spinners = require("copilot-lualine.spinners").dots,
          },
          show_colors = false,
          show_loading = true,
          on_click = function()
            local copilot_lualine = require("copilot-lualine")
            if copilot_lualine.is_enabled() then
              vim.cmd([[Copilot disable]])
            else
              vim.cmd([[Copilot enable]])
            end
          end,
        },
      },
      lualine_z = {
        {
          "location",
          padding = { right = 0, left = 0 },
          separator = { left = "" },
        },
        {
          "progress",
          separator = { right = "" },
          padding = { left = 1 },
          icon = constants.icons.ScrollText,
        },
      },
    },
    inactive_sections = {
      lualine_c = {
        file_component,
      },
    },
    extensions = { "lazy", "quickfix", "nvim-dap-ui", "oil" },
  })
end

return {
  {
    "nvim-lualine/lualine.nvim",
    config = lualine_config,
    event = "VeryLazy",
  },
  {
    "nvim-tree/nvim-web-devicons",
  },

  { "AndreM222/copilot-lualine" },
}
