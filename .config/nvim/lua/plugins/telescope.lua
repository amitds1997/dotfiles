local telescope_config = function ()
  local telescope = require("telescope")
  local trouble  = require("trouble.providers.telescope")

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
      mappings = {
        i = { ["<c-t>"] = trouble.open_with_trouble },
        n = { ["<c-t>"] = trouble.open_with_trouble },
      },
    },
  })

  local built_in = require("telescope.builtin")

  require("which-key").register({
    ["<Leader>t"] = {
      name = "telescope",
      f = { built_in.find_files, "Find file" },
      r = { built_in.oldfiles, "Open recent file" },
      g = { built_in.git_files, "Find file in git repo" },
      w = { built_in.live_grep, "Find word" },
      b = { built_in.buffers, "Select from open buffers" },
      k = { built_in.keymaps, "Open keymap window" },
      ["/"] = { built_in.current_buffer_fuzzy_find, "Fuzzy find in the current buffer" },
    }
  })

  telescope.load_extension("fzf")
end

return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  branch = "0.1.x",
  config = telescope_config,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "folke/which-key.nvim", -- This is not a dependency but we use it in the set-up
  },
}
