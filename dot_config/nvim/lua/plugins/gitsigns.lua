return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  -- event = { "BufRead", "BufNewFile" },
  dependencies = {
    {
      "linrongbin16/gitlinker.nvim",
      opts = true,
    },
  },
  opts = {
    signcolumn = true,
    numhl = true,
    diff_opts = { internal = true },
    on_attach = function(bufnr)
      local gs, wk = package.loaded.gitsigns, package.loaded["which-key"]
      local gs_buf_opts = { buffer = bufnr, mode = { "n", "v" } }

      local wk_maps = {
        ["<leader>g"] = {
          name = "git",

          -- Hunk movement
          ["["] = {
            function()
              if vim.wo.diff then
                return "<leader>g["
              end
              vim.schedule(function()
                gs.prev_hunk()
              end)
              return "<Ignore>"
            end,
            "Jump to prev hunk",
            expr = true,
          },
          ["]"] = {
            function()
              if vim.wo.diff then
                return "<leader>g]"
              end
              vim.schedule(function()
                gs.next_hunk()
              end)
              return "<Ignore>"
            end,
            "Jump to next hunk",
            expr = true,
          },

          -- Preview hunk changes
          p = { gs.preview_hunk, "Preview hunk" },
          P = { gs.preview_hunk_inline, "Preview hunk inline" },

          -- Stage changes
          s = { gs.stage_hunk, "Stage hunk" },
          S = { gs.stage_buffer, "Stage buffer" },

          -- Reset changes
          r = { gs.reset_hunk, "Reset hunk" },
          R = { gs.reset_buffer, "Reset buffer" },
          u = { gs.undo_stage_hunk, "Undo hunk staging" },

          d = { gs.diffthis, "Git diff (side-by-side)" },
          b = {
            function()
              gs.blame_line({ full = true })
            end,
            "Git blame current line with preview",
          },
          e = {
            name = "extras",

            l = {
              function()
                require("gitlinker").link({ action = require("gitlinker.actions").clipboard })
              end,
              "Copy share-able path URIs",
            },
          },
        },
        ["<leader>gt"] = {
          name = "gitsigns-toggle",

          -- Toggle things
          b = { gs.toggle_current_line_blame, "Toggle current line's blame" },
          d = { gs.toggle_deleted, "Toggle deleted lines" },
        },
      }

      wk.register(wk_maps, gs_buf_opts)
    end,
  },
}
