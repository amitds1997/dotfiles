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
        enable = false, -- stylua runs using conform
      },
      codeLens = {
        enable = true,
      },
      diagnostics = {
        disable = {
          "unused-local", -- Covered by selene.
        },
      },
      telemetry = {
        enable = false,
      },
      typeFormat = {
        config = {
          -- Adds it's own variant of whitespaces which does not match with the rest of the code. See: https://github.com/LuaLS/lua-language-server/issues/2689
          format_line = "false",
        },
      },
    },
    workspace = {
      vim.env.VIMRUNTIME,
    },
  },
}
