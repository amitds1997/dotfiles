local prefixPaths = { "magic", "text" }
assert(
  #prefixPaths == 1,
  ("There should be only one unique path per compressed upload. Current paths: %s"):format(vim.inspect(prefixPaths))
)
