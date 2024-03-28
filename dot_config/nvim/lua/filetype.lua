vim.filetype.add({
  filename = {
    [".eslintrc.json"] = "jsonc",
  },
  pattern = {
    [".*/hypr/.*%.conf"] = "hyprlang",
    ["tsconfig*.json"] = "jsonc",
    [".*/%.vscode/.*%.json"] = "jsonc",
  },
})
