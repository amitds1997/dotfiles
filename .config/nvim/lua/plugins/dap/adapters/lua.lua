return function ()
  local dap = require("dap")

  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Attach to the existing Neovim instance",
    }
  }

  dap.adapters.nlua = function (callback, config)
    callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
  end

  vim.keymap.set("n", "<leader>dls", function () require("osv").launch({ port = 8086 }) end,
    { desc = "[d]ebugger: Launch [l]ua debugger [s]erver" })
  vim.keymap.set("n", "<leader>dld", function () require("osv").run_this() end,
    { desc = "[d]ebugger: Launch [l]ua [d]ebugger" })
end
