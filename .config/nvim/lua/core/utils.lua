local Utils = {}

Utils.is_windows = package.config:sub(1, 1) == "\\" and true or false
Utils.path_sep = Utils.is_windows and "\\" or "/"

-- Join paths correctly using the correct path separator
function Utils.path_join(...)
  return table.concat({ ... }, Utils.path_sep)
end

function Utils.is_nvim_config()
  local path = vim.loop.fs_realpath(vim.api.nvim_buf_get_name(0))
  if path then
    path = vim.fs.normalize(path)
    local config_root = vim.loop.fs_realpath(vim.fn.stdpath("config")) or vim.fn.stdpath("config")
    config_root = vim.fs.normalize(config_root)
    return path:find(config_root, 1, true) == 1
  end
  return false
end

return Utils
