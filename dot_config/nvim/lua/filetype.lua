vim.filetype.add({
  filename = {
    [".eslintrc.json"] = "jsonc",
    [".luarc.json"] = "jsonc",
  },
  pattern = {
    [".*/hypr/.*%.conf"] = "hyprlang",
    ["tsconfig*.json"] = "jsonc",
    [".*/%.vscode/.*%.json"] = "jsonc",
    [".*%.pyn"] = "pyn",
  },
})
