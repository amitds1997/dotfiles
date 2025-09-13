local is_ok, MiniGit = pcall(require, "mini.git")
if not is_ok then
  vim.notify_once "`mini.git` is required for this to work"
end

local M = {}

M.get_line_blame = function()
  local repo_info = MiniGit.get_buf_data(0)

  if repo_info == nil or repo_info.root == nil then
    vim.notify("Not in a Git repo", vim.log.levels.WARN)
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local file = vim.api.nvim_buf_get_name(0)
  local root = repo_info.root
  local cmd = { "git", "-C", root, "log", "-n", 3, "-u", "-L", line .. ",+1:" .. file }
  vim.print("Running cmd" .. table.concat(cmd, " "))
  return require("utils.float").float_term(cmd, {
    ft = "git",
  })
end

return M
