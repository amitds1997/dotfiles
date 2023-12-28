local telescope_config = function()
  local telescope = require("telescope")
  local trouble = require("trouble.providers.telescope")
  local actions = require("telescope.actions")

  telescope.setup({
    defaults = {
      preview = {
        filesize_limit = 0.1,
      },
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
        n = { ["<c-t>"] = trouble.open_with_trouble, ["<C-u>"] = false },
      },
    },
    pickers = {
      colorscheme = {
        initial_mode = "normal",
        enable_preview = true,
      },
      buffers = {
        initial_mode = "normal",
        previewer = false,
        ignore_current_buffer = true,
        layout_config = {
          width = 0.4,
          height = 0.7,
        },
        mappings = {
          i = {
            ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
          },
          n = {
            ["d"] = actions.delete_buffer,
            ["<Tab>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
          },
        },
      },
    },
  })

  local built_in = require("telescope.builtin")
  telescope.load_extension("fzf")
  telescope.load_extension("projects")

  require("which-key").register({
    ["<leader>t"] = {
      name = "telescope",
      b = { built_in.buffers, "Select from open buffers" },
      c = { built_in.colorscheme, "Change colorscheme" },
      f = { built_in.find_files, "Find file" },
      g = { built_in.git_files, "Find file in git repo" },
      k = { built_in.keymaps, "Open keymap window" },
      o = { built_in.oldfiles, "Open previously opened files" },
      p = { telescope.extensions.projects.projects, "Open projects window" },
      r = { built_in.resume, "Resume last telescope operation" },
      w = { built_in.live_grep, "Find word" },
      [":"] = { built_in.command_history, "Show commands executed recently and run them on <CR>" },
      ["/"] = { built_in.current_buffer_fuzzy_find, "Fuzzy find in the current buffer" },
    },
  })
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
    "folke/which-key.nvim",
  },
}
