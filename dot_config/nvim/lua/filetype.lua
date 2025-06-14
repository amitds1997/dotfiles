vim.filetype.add {
  extension = {
    es6 = "javascript",
    mts = "javascript",
    cts = "javascript",
  },
  filename = {
    [".eslintrc"] = "json",
    [".prettierrc"] = "json",
    [".babelrc"] = "json",
    [".stylelintrc"] = "json",
  },
  pattern = {
    [".env.*"] = "sh",
    [".*/hypr/.*%.conf"] = "hyprlang",
    ["tsconfig*.json"] = "jsonc",
    [".*/%.vscode/.*%.json"] = "jsonc",
  },
}
