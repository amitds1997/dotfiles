local lua_dap_adapter_config = function ()
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
end

return {
  "jbyuki/one-small-step-for-vimkind",
  config = lua_dap_adapter_config,
}
