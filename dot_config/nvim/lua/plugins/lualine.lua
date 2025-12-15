--- Get all running LSP servers and copilot status
--- @return string[] lsp_server_names
--- @return boolean is_copilot_active
local function get_lsp_info()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    return {}, false
  end

  local lsp_info = require("core.constants").lsps
  table.sort(clients, function(a, b)
    local a_priority = lsp_info[a.name or "LSP"] and lsp_info[a.name or "LSP"].priority or 0
    local b_priority = lsp_info[b.name or "LSP"] and lsp_info[b.name or "LSP"].priority or 0
    return a_priority > b_priority
  end)

  local client_info = vim.iter(clients):fold({}, function(acc, client)
    local name = lsp_info[client.name] and lsp_info[client.name].name or client.name
    table.insert(acc, name)
    return acc
  end)

  -- We exclude Copilot LSP from LSP count, we have a special icon for that
  local updated_client_info = vim.tbl_filter(function(name)
    return name ~= "copilot_ls"
  end, client_info)

  return updated_client_info, #client_info ~= #updated_client_info
end

--- Show LSP clients in the statusline
local function lsp_component()
  local server_names = get_lsp_info()
  if #server_names == 0 then
    return ""
  end

  local lsp_str = server_names[1]

  if #server_names > 1 then
    lsp_str = lsp_str .. ("+%s"):format(#server_names - 1)
  end

  return lsp_str
end

local function is_macro_recording()
  local rec = vim.fn.reg_recording()
  return rec ~= "" and (" ⏺ recording @" .. rec .. " ") or ""
end

local function is_copilot_active()
  return vim.lsp.is_enabled "copilot_ls" and "󰚩 " or "󱚧 "
end

return {
  "nvim-lualine/lualine.nvim",
  event = { "VeryLazy" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      icons_enabled = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { { "filename", file_status = true, symbols = { unnamed = "" } } },
      lualine_c = { "diagnostics" },
      lualine_x = {
        "require('custom.lualine.codecompanion').update_status()",
        "searchcount",
        "selectwoncount",
        is_macro_recording,
      },
      lualine_y = {
        lsp_component,
        {
          is_copilot_active,
          on_click = function()
            local seq = vim.api.nvim_replace_termcodes("<leader>ta", true, false, true)
            vim.api.nvim_feedkeys(seq, "m", false)
          end,
        },
        "branch",
      },
      lualine_z = { "location" },
    },
    extensions = { "lazy", "mason" },
  },
  config = function(_, opts)
    table.insert(opts.sections.lualine_x, 1, require "custom.lualine.codecompanion")
    require("lualine").setup(opts)
  end,
}
