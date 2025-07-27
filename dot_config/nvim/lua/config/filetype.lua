local bf_config = require("settings").big_file

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
    -- Mark all files bigger than 500 KB as "bigfile"
    [".*"] = function(path, buf)
      if not path or not buf or vim.bo[buf].filetype == "bigfile" then
        return
      end

      if path ~= vim.api.nvim_buf_get_name(buf) then
        return
      end

      local size = vim.fn.getfsize(path)
      if size <= 0 then
        return
      end

      if size >= bf_config.size_in_bytes then
        return "bigfile"
      end

      return vim.api.nvim_buf_line_count(buf) > bf_config.line_count and "bigfile" or nil
    end,
  },
}
