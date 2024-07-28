return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
      signcolumn = true,
      numhl = true,
      diff_opts = { internal = true },
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        vim.keymap.set({ "n", "v" }, "[", function()
          if vim.wo.diff then
            return "<leader>g["
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { desc = "Jump to previous diff hunk", expr = true, buffer = bufnr })
        vim.keymap.set({ "n", "v" }, "]", function()
          if vim.wo.diff then
            return "<leader>g]"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { desc = "Jump to next diff hunk", expr = true, buffer = bufnr })
        vim.keymap.set({ "n", "v" }, "<leader>gp", gs.preview_hunk, { desc = "Preview hunk", buffer = bufnr })
        vim.keymap.set(
          { "n", "v" },
          "<leader>gP",
          gs.preview_hunk_inline,
          { desc = "Preview hunk inline", buffer = bufnr }
        )

        -- Stage changes
        vim.keymap.set({ "n", "v" }, "<leader>gs", gs.stage_hunk, { desc = "Stage hunk", buffer = bufnr })
        vim.keymap.set({ "n", "v" }, "<leader>gS", gs.stage_buffer, { desc = "Stage buffer", buffer = bufnr })

        -- Reset changes
        vim.keymap.set({ "n", "v" }, "<leader>gr", gs.reset_hunk, { desc = "Reset hunk", buffer = bufnr })
        vim.keymap.set({ "n", "v" }, "<leader>gR", gs.reset_buffer, { desc = "Reset buffer", buffer = bufnr })
        vim.keymap.set({ "n", "v" }, "<leader>gu", gs.undo_stage_hunk, { desc = "Undo hunk staging", buffer = bufnr })

        vim.keymap.set({ "n", "v" }, "<leader>gd", gs.diffthis, { desc = "Git diff (side-by-side)", buffer = bufnr })
        -- Preview hunk changes
        vim.keymap.set({ "n", "v" }, "<leader>gb", function()
          gs.blame_line({ full = true })
        end, { desc = "Git blame current line with preview", buffer = bufnr })
        vim.keymap.set({ "n", "v" }, "<leader>gel", function()
          require("gitlinker").link({ action = require("gitlinker.actions").clipboard })
        end, { desc = "Copy share-able path URIs", buffer = bufnr })
        -- Toggle things
        vim.keymap.set(
          { "n", "v" },
          "<leader>gtb",
          gs.toggle_current_line_blame,
          { desc = "Toggle current line's blame", buffer = bufnr }
        )
        vim.keymap.set(
          { "n", "v" },
          "<leader>gtd",
          gs.toggle_deleted,
          { desc = "Toggle deleted lines", buffer = bufnr }
        )

        -- wk.register(gs_buf_opts)
      end,
    },
  },
  {
    "linrongbin16/gitlinker.nvim",
    opts = true,
  },
}
