---@module 'lazy'
---@type LazyPluginSpec
return {
  "mason-org/mason.nvim",
  build = ":MasonUpdate",
  cmd = "Mason",
  event = { "BufNewFile", "BufReadPre" },
  opts_extend = { "ensure_installed" },
  opts = {
    pip = {
      upgrade_pip = true,
    },
    PATH = "append",
    ui = {
      backdrop = 100,
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    local registry = require "mason-registry"
    registry:on("package:install:success", function()
      vim.defer_fn(function()
        require("lazy.core.handler.event").trigger {
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        }
      end, 100)
    end)

    registry.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = registry.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)
  end,
}
