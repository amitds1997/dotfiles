local function mason_config()
  require("mason").setup({
    log_level = vim.log.levels.DEBUG,
    ui = { border = "rounded", icons = require("nvim-nonicons.extentions.mason").icons },
    pip = {
      upgrade_pip = true,
    },
    PATH = "append",
  })

  for _, pkg in ipairs(require("core.vars").mason_auto_installed) do
    require("custom.mason_installer"):install(pkg)
  end
end

return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  build = ":MasonUpdate",
  config = mason_config,
}
