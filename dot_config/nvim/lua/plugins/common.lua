local meta_file_types = require("settings").meta_filetypes

---@module 'lazy'
---@type LazyPluginSpec[]
return {
  {
    -- Guess and set correct indent levels based on file
    "nmac427/guess-indent.nvim",
    event = "BufReadPost",
    opts = {
      buftype_exclude = meta_file_types,
    },
  },
  {
    -- Kitty scrollback
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = {
      "KittyScrollbackGenerateKittens",
      "KittyScrollbackCheckHealth",
      "KittyScrollbackGenerateCommandLineEditing",
    },
    event = { "User KittyScrollbackLaunch" },
    version = "*",
    config = function()
      require("kitty-scrollback").setup()
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    cmd = "Gitsigns",
    opts = {
      signcolumn = true,
      numhl = true,
      on_attach = function(bufnr)
        local gitsigns = require "gitsigns"

        local function map(mode, l, r, desc, opts)
          opts = opts or {}
          opts.buffer = bufnr
          opts.desc = desc
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            ---@diagnostic disable-next-line: param-type-mismatch
            gitsigns.nav_hunk "next"
          end
        end, "Next change")

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            ---@diagnostic disable-next-line: param-type-mismatch
            gitsigns.nav_hunk "prev"
          end
        end, "Prev change")

        -- Actions
        map("n", "<leader>gs", gitsigns.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gitsigns.reset_hunk, "Reset hunk")

        map("v", "<leader>gs", function()
          gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, "Stage hunk")

        map("v", "<leader>gr", function()
          gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, "Reset hunk")

        map("n", "<leader>gS", gitsigns.stage_buffer, "Stage buffer")
        map("n", "<leader>gR", gitsigns.reset_buffer, "Reset buffer")
        map("n", "<leader>gp", gitsigns.preview_hunk, "Preview hunk")
        map("n", "<leader>gi", gitsigns.preview_hunk_inline, "Preview hunk (inline)")

        -- Toggles
        map("n", "<leader>gb", gitsigns.toggle_current_line_blame, "Toggle current line blame")
        map("n", "<leader>tw", gitsigns.toggle_word_diff, "Toggle word diff")

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk")
      end,
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    dependencies = { { "mskelton/termicons.nvim", build = false } },
    config = function()
      require("termicons").setup()
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        winblend = 0,
        should_preview_cb = function(bufnr, _)
          if vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == "bigfile" then
            return false
          end

          return true
        end,
      },
    },
  },
}
