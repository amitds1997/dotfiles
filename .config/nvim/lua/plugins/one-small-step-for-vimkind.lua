local lua_adapter_config = function ()
  local dap = require("dap")

  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Attach to running Neovim instance",
      host = "127.0.0.1",
      port = 8086, -- This port is not used; it's just a placeholder
    }
  }

  dap.adapters.nlua = function (on_config_cb, chosen_config)
    on_config_cb({ type = "server", host = chosen_config.host, port = chosen_config.port })
  end
end

return {
  "jbyuki/one-small-step-for-vimkind",
  config = lua_adapter_config,
  event = "BufEnter *.lua",
  dependencies = "mfussenegger/nvim-dap"
}
