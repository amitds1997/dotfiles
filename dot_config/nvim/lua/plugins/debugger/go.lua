local function setup_go_dap()
  require("dap-go").setup({
    dap_configurations = {
      {
        -- Must be "go" or it will be ignored by the plugin
        type = "go",
        name = "Attach remote",
        mode = "remote",
        request = "attach",
      },
    },
  })
end

return {
  "leoluz/nvim-dap-go",
  event = "BufEnter *.go",
  config = setup_go_dap,
}
