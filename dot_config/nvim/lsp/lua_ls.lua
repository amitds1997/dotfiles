---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",
        semicolon = "Disable",
        setType = true,
      },
      format = {
        -- stylua runs using conform
        enable = false,
      },
      codeLens = {
        enable = true,
      },
      diagnostics = {
        disable = {
          "unused-local", -- Covered by selene.
        },
      },
    },
    workspace = {
      vim.env.VIMRUNTIME,
    },
  },
}
