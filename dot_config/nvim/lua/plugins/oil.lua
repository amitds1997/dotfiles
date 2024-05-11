local function check_hidden(patterns, name)
  for _, pat in ipairs(patterns) do
    if string.find(name, pat) ~= nil then
      return true
    end
  end
  return false
end

return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  -- event = "VeryLazy",
  keys = {
    { "<leader>we", desc = "Open Oil explorer" },
  },
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, _)
        return check_hidden(require("core.vars").oil.hidden_file_patterns, name)
      end,
      is_always_hidden = function(name, _)
        return check_hidden(require("core.vars").oil.always_hidden_patterns, name)
      end,
    },
    float = {
      win_options = {
        winhl = "Normal:Normal,Float:Float",
      },
    },
    preview = {
      win_options = {
        winhl = "Normal:Normal,Float:Float",
      },
    },
  },
}
