local U = {}

-- selene: allow(incorrect_standard_library_use)
U.is_windows = package.config:sub(1, 1) == "\\" and true or false
U.path_sep = U.is_windows and "\\" or "/"
U.uv = vim.fn.has("nvim-0.10") == 1 and vim.uv or vim.loop
-- Join paths correctly using the correct path separator
function U.path_join(...)
  return table.concat({ ... }, U.path_sep)
end

---@return table[]
function U.get_plugins(init_path)
  assert(init_path ~= nil, "File path to the current file should not be nil")

  local files = vim.fs.find(function(name, _)
    return name ~= "init.lua"
  end, {
    type = "file",
    limit = math.huge,
    path = init_path,
  })

  local base_path
  for dir in vim.fs.parents(init_path) do
    if vim.fs.basename(dir) == "lua" then
      base_path = vim.fs.normalize(dir)
      break
    end
  end

  local plugins = {}
  for _, filename in ipairs(files) do
    filename = filename:sub(#base_path + 2, -5)
    table.insert(plugins, require(filename))
  end

  return plugins
end

return U
