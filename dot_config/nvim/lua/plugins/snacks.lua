---@module 'lazy'
---@type LazyPluginSpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  enabled = true,
  lazy = false,
  keys = {
    -- {
    --   "<leader>pp",
    --   function()
    --     require("snacks").picker()
    --   end,
    --   desc = "Pick picker",
    -- },
    -- {
    --   "<leader>ps",
    --   function()
    --     require("snacks").picker.smart()
    --   end,
    --   desc = "Smart find files",
    -- },
    -- {
    --   "<leader>pz",
    --   function()
    --     require("snacks").picker.zoxide()
    --   end,
    --   desc = "Open zoxide-based directory",
    -- },
    -- -- Histories
    -- {
    --   "<leader>phu",
    --   function()
    --     require("snacks").picker.undo()
    --   end,
    --   desc = "Undo history",
    -- },
    -- Git browse
    {
      "<leader>mob",
      function()
        require("snacks").gitbrowse.open {
          what = "branch",
        }
      end,
      desc = "Git branch",
      mode = { "n", "v" },
    },
    {
      "<leader>moc",
      function()
        require("snacks").gitbrowse.open {
          what = "commit",
        }
      end,
      desc = "Git commit",
      mode = { "n", "v" },
    },
    {
      "<leader>mor",
      function()
        require("snacks").gitbrowse.open {
          what = "repo",
        }
      end,
      desc = "Git repo",
      mode = { "n", "v" },
    },
    {
      "<leader>mof",
      function()
        require("snacks").gitbrowse.open {
          what = "file",
        }
      end,
      desc = "Git file",
      mode = { "n", "v" },
    },
    {
      "<leader>mop",
      function()
        require("snacks").gitbrowse.open {
          what = "permalink",
          open = function(url)
            vim.fn.setreg("+", url)
            vim.ui.open(url)
          end,
        }
      end,
      desc = "Git permalink",
      mode = { "n", "v" },
    },
  },
}
