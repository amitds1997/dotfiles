local ok, wk = pcall(require, "which-key")

if not ok then
  vim.notify_once("which-key.nvim is needed to register keymaps correctly", vim.log.levels.ERROR)
  return
else
  for _, keymap_filepath in
    ipairs(vim.fn.globpath(vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "keymaps"), "*.lua", true, true))
  do
    local keymap_import_name = keymap_filepath:match(".*/(.*/.*)%.lua")
    wk.register(require(keymap_import_name))
  end
end
