local Utils = {}

-- selene: allow(incorrect_standard_library_use)
Utils.is_windows = package.config:sub(1, 1) == "\\" and true or false
Utils.path_sep = Utils.is_windows and "\\" or "/"

-- Join paths correctly using the correct path separator
function Utils.path_join(...)
  return table.concat({ ... }, Utils.path_sep)
end

return Utils
