local telescope_config = function()
  local telescope = require("telescope")
  local actions = require("telescope.actions")

  telescope.setup({
    defaults = {
      preview = {
        filesize_limit = 0.1,
      },
      initial_mode = "insert",
      prompt_prefix = " " .. require("nvim-nonicons").get("telescope") .. "  ",
      layout_strategy = "horizontal",
      path_display = { "absolute" },
      file_ignore_patterns = { ".git/", "node_modules/", ".cache", "*.pdf", "*.zip" },
      results_title = false,
      selection_caret = "  ",
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
    pickers = {
      colorscheme = {
        initial_mode = "normal",
        enable_preview = true,
      },
      find_files = {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--no-require-git" },
        hidden = true,
      },
      buffers = {
        initial_mode = "normal",
        layout_strategy = "vertical",
        layout_config = {
          mirror = true,
          prompt_position = "top",
        },
        sort_mru = true,
        sort_lastused = true,
        mappings = {
          i = {
            ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
          },
          n = {
            ["q"] = actions.close,
            ["d"] = function(bufnr)
              local current_picker = require("telescope.actions.state").get_current_picker(bufnr)
              current_picker:delete_selection(function(selection)
                local force = vim.api.nvim_get_option_value("buftype", {
                  buf = selection.bufnr,
                }) == "terminal"
                require("mini.bufremove").delete(selection.bufnr, force)
              end)
            end,
            ["<Tab>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
          },
        },
      },
    },
  })

  local built_in = require("telescope.builtin")
  telescope.load_extension("live_grep_args")

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
      t = { "<cmd>Telescope<CR>", "Open telescope" },
      w = { telescope.extensions.live_grep_args.live_grep_args, "Find word" },
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
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
    },
  },
}
