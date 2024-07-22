local telescope_config = function()
  local telescope = require("telescope")
  local actions = require("telescope.actions")

  telescope.setup({
    defaults = {
      path_display = {
        "filename_first",
      },
      preview = {
        filesize_limit = 0.1,
      },
      initial_mode = "insert",
      prompt_prefix = " " .. require("nvim-nonicons").get("telescope") .. "  ",
      layout_strategy = "horizontal",
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
  telescope.load_extension("fzf")

  vim.keymap.set("n", "<leader>t/", built_in.current_buffer_fuzzy_find, {
    desc = "Fuzzy find in the current buffer",
  })
  vim.keymap.set("n", "<leader>t/", built_in.current_buffer_fuzzy_find, { desc = "Fuzzy find in the current buffer" })
  vim.keymap.set(
    "n",
    "<leader>t:",
    built_in.command_history,
    { desc = "Show commands executed recently and run them on <CR>" }
  )
  vim.keymap.set("n", "<leader>tb", built_in.buffers, { desc = "Select from open buffers" })
  vim.keymap.set("n", "<leader>tc", built_in.colorscheme, { desc = "Change colorscheme" })
  vim.keymap.set("n", "<leader>tf", built_in.find_files, { desc = "Find file" })
  vim.keymap.set("n", "<leader>tg", built_in.git_files, { desc = "Find file in git repo" })
  vim.keymap.set("n", "<leader>tk", built_in.keymaps, { desc = "Open keymap window" })
  vim.keymap.set("n", "<leader>to", built_in.oldfiles, { desc = "Open previously opened files" })
  vim.keymap.set("n", "<leader>tp", telescope.extensions.projects.projects, { desc = "Open projects window" })
  vim.keymap.set("n", "<leader>tr", built_in.resume, { desc = "Resume last telescope operation" })
  vim.keymap.set("n", "<leader>ts", built_in.lsp_document_symbols, { desc = "Get LSP symbols from current document" })
  vim.keymap.set("n", "<leader>tt", "<cmd>Telescope<CR>", { desc = "Open telescope" })
  vim.keymap.set("n", "<leader>tw", telescope.extensions.live_grep_args.live_grep_args, { desc = "Find word" })
end

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>t", desc = "Telescope" },
    },
    cmd = "Telescope",
    config = telescope_config,
    dependencies = {},
  },
  { "nvim-lua/plenary.nvim" },
  { "folke/which-key.nvim" },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    -- This will not install any breaking changes.
    -- For major updates, this must be adjusted manually.
    version = "^1.0.0",
  },
}
