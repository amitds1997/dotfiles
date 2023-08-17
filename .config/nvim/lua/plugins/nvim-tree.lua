local nvim_tree_config = function ()
  require("nvim-tree").setup({
    disable_netrw = false,
    hijack_cursor = true,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = true,
    select_prompts = true,
    sync_root_with_cwd = false,
    renderer = {
      group_empty = true,
      indent_markers = {
        enable = true,
      },
      root_folder_label = false,
      highlight_opened_files = "icon",
      icons = {
        git_placement = "signcolumn",
        glyphs = {
          git = {
            unstaged = "!",
            staged = "+",
            unmerged = "",
            renamed = "➜",
            untracked = "?",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    filters = {
      dotfiles = false,
      custom = { "^.git$", "^node_modules$", "^.cache$", ".DS_Store" },
    },
  })
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = nvim_tree_config,
  keys = { "<Leader>e" },
}
