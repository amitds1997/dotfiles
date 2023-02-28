return function ()
  require("nvim-tree").setup({
    disable_netrw = false,
    hijack_cursor = true,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = true,
    open_on_setup = false,
    select_prompts = true,
    sync_root_with_cwd = true,
    view = {
      hide_root_folder = true,
    },
    renderer = {
      group_empty = true,
      indent_markers = {
        enable = true,
      },
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

  vim.keymap.set(
    "n",
    "<Leader>e",
    ":NvimTreeToggle<CR>",
    { silent = true, noremap = true, desc = "Toggle File [e]xplorer" }
  )
end
