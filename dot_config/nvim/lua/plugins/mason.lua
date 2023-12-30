local function mason_config()
  require("mason").setup({
    ui = { border = "rounded", icons = require("nvim-nonicons.extentions.mason").icons },
    pip = {
      upgrade_pip = true,
    },
  })
end

return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  build = ":MasonUpdate",
  config = mason_config,
}
