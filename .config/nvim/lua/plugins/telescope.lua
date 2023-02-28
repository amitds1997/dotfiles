local telescope_config = function ()
  local telescope = require("telescope")

  telescope.setup({
    defaults = {
      initial_mode = "insert",
      prompt_prefix = "  ",
      layout_strategy = "horizontal",
      path_display = { "absolute" },
      file_ignore_patterns = { ".git/", "node_modules/", ".cache", "*.pdf", "*.zip" },
      selection_caret = "  ",
      results_title = false,
      layout_width = {
        horizontal = {
          preview_width = 0.5,
        },
      },
      pickers = {
        keymaps = {
          theme = "dropdown",
        },
      },
    },
  })

  local built_in = require("telescope.builtin")
  vim.keymap.set(
    "n",
    "<Leader>ff",
    built_in.find_files,
    { silent = true, noremap = true, desc = "Telescope: [f]ind [f]iles" }
  )
  vim.keymap.set(
    "n",
    "<Leader>fw",
    built_in.live_grep,
    { silent = true, noremap = true, desc = "Telescope: [f]ind [w]ord" }
  )
  vim.keymap.set(
    "n",
    "<Leader>fg",
    built_in.git_files,
    { silent = true, noremap = true, desc = "Telescope: [f]ind [g]it files" }
  )

  telescope.load_extension("fzf")
end

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  config = telescope_config,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  keys = { "<Leader>ff", "<Leader>fw", "<Leader>fg" },
}
