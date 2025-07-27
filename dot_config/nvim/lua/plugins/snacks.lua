return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    indent = {
      enabled = true,
      filter = function(buf)
        return vim.g.snacks_indent ~= false
          and vim.b[buf].snacks_indent ~= false
          and not vim.tbl_contains(require("settings").meta_filetypes, vim.bo[buf].buftype)
      end,
    },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        easing = "inOutQuad",
      },
    },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    toggle = {
      icon = {
        enabled = "󰨚 ",
        disabled = "󰨙 ",
      },
      color = {
        enabled = "green",
        disabled = "gray",
      },
    },
  },
  keys = {
    {
      "<leader>pf",
      function()
        require("snacks").picker.files()
      end,
      desc = "Find files",
    },
    {
      "<leader>pr",
      function()
        require("snacks").picker.recent()
      end,
      desc = "Find recent files",
    },
    {
      "<leader>pn",
      function()
        require("snacks").picker.notifications()
      end,
      desc = "Notification history",
    },
    {
      "<leader>pc",
      function()
        require("snacks").picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
    {
      "<leader>ps",
      function()
        require("snacks").picker.smart()
      end,
      desc = "Smart find files",
    },
    {
      "<leader>p/",
      function()
        require("snacks").picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>p?",
      function()
        require("snacks").picker.grep_buffers()
      end,
      desc = "Grep open buffers",
    },
    {
      "<leader>pz",
      function()
        require("snacks").zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>pZ",
      function()
        require("snacks").zen.zoom()
      end,
      desc = "Toggle Zen Mode",
    },
    -- Histories
    {
      "<leader>phc",
      function()
        require("snacks").picker.command_history()
      end,
      desc = "Command history",
    },
    {
      "<leader>phs",
      function()
        require("snacks").picker.search_history()
      end,
      desc = "Search history",
    },
    {
      "<leader>phn",
      function()
        require("snacks").notifier.show_history()
      end,
      desc = "Notification history",
    },
    {
      "<leader>phu",
      function()
        require("snacks").picker.undo()
      end,
      desc = "Undo history",
    },
    -- Git
    {
      "<leader>pgw",
      function()
        require("snacks").picker.git_browse()
      end,
      desc = "Git browse",
      mode = { "n", "v" },
    },
    {
      "<leader>pgf",
      function()
        require("snacks").picker.git_files()
      end,
      desc = "Find Git files",
    },
    {
      "<leader>pgb",
      function()
        require("snacks").picker.git_branches()
      end,
      desc = "Find Git branches",
    },
    {
      "<leader>pgd",
      function()
        require("snacks").picker.git_diff()
      end,
      desc = "Git Diff (Hunks)",
    },
    {
      "<leader>pgl",
      function()
        require("snacks").picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>pgL",
      function()
        require("snacks").picker.git_log_line()
      end,
      desc = "Git Log Line",
    },
    {
      "<leader>pgs",
      function()
        require("snacks").picker.git_status()
      end,
      desc = "Git Status",
    },
    {
      "<leader>pgS",
      function()
        require("snacks").picker.git_stash()
      end,
      desc = "Git Stash",
    },
    {
      "<leader>pgF",
      function()
        require("snacks").picker.git_log_file()
      end,
      desc = "Git Log File",
    },
    {
      "<leader>pgg",
      function()
        require("snacks").lazygit()
      end,
      desc = "Open Lazygit",
    },
    -- Open Neovim News
    {
      "<leader>N",
      function()
        require("snacks").win {
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        }
      end,
      desc = "Neovim News",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup globals for debugging
        local debug_print = function(...)
          require("snacks").debug.inspect(...)
        end
        vim.print = debug_print

        require("snacks").toggle.option("spell", { name = "Spelling" }):map "<leader>ts"
        require("snacks").toggle.option("wrap", { name = "Wrap" }):map "<leader>tw"
        require("snacks").toggle
          .option("background", { off = "light", on = "dark", name = "Dark background" })
          :map "<leader>tb"
        require("snacks").toggle.option("relativenumber", { name = "Relative Line numbering" }):map "<leader>tL"
        require("snacks").toggle.line_number():map "<leader>tl"
        require("snacks").toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
          :map "<leader>tc"
        require("snacks").toggle.treesitter():map "<leader>tT"
        require("snacks").toggle.inlay_hints():map "<leader>th"
        require("snacks").toggle.indent():map "<leader>tg"
        require("snacks").toggle.dim():map "<leader>tD"
      end,
    })
  end,
}
