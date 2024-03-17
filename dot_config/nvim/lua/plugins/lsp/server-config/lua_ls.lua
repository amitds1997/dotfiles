return {
  Lua = {
    runtime = {
      version = "LuaJIT",
    },
    hint = {
      enable = true,
    },
    format = {
      -- stylua runs using conform
      enable = false,
    },
    codeLens = {
      enable = true,
    },
  },
  workspace = {
    vim.env.VIMRUNTIME,
  },
}
