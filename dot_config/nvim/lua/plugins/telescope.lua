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
      prompt_prefix = "   ",
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

  telescope.load_extension("live_grep_args")
  telescope.load_extension("fzf")
end

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>t/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy find in the current buffer" },
      {
        "<leader>t:",
        "<cmd>Telescope command_history<CR>",
        desc = "Show commands executed recently and run them on <CR>",
      },
      { "<leader>tb", "<cmd>Telescope buffers<CR>", desc = "Select from open buffers" },
      { "<leader>tc", "<cmd>Telescope colorscheme<CR>", desc = "Change colorscheme" },
      { "<leader>tf", "<cmd>Telescope find_files<CR>", desc = "Find file" },
      { "<leader>tg", "<cmd>Telescope git_files<CR>", desc = "Find file in git repo" },
      { "<leader>tk", "<cmd>Telescope keymaps<CR>", desc = "Open keymap window" },
      { "<leader>to", "<cmd>Telescope oldfiles<CR>", desc = "Open previously opened files" },
      { "<leader>tp", "<cmd>Telescope projects<CR>", desc = "Open projects window" },
      { "<leader>tr", "<cmd>Telescope resume<CR>", desc = "Resume last telescope operation" },
      { "<leader>ts", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Get LSP symbols from current document" },
      { "<leader>tt", "<cmd>Telescope<CR>", desc = "Open telescope" },
      { "<leader>tw", "<cmd>Telescope live_grep_args<CR>", desc = "Find word" },
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
