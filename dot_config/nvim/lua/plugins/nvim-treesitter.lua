local ensure_installed_parsers = {
  "bash",
  "c",
  "comment",
  "cpp",
  "css",
  "csv",
  "diff",
  "dart",
  "dockerfile",
  "editorconfig",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "helm",
  "html",
  "http",
  "hyprlang",
  "ini",
  "javascript",
  "java",
  "json",
  "json5",
  "just",
  "kotlin",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "requirements",
  "rust",
  "scala",
  "scheme",
  "sql",
  "swift",
  "ssh_config",
  "terraform",
  "toml",
  "typescript",
  "vimdoc",
  "xml",
  "yaml",
}

---@module 'lazy'
---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          max_lines = 3,
          multiwindow = true,
          multiline_threshold = 2,
        },
        keys = {
          {
            "[c",
            function()
              require("treesitter-context").go_to_context(vim.v.count1)
            end,
            desc = "Jump to outer context",
          },
        },
      },
    },
    config = function(_, opts)
      local ts = require "nvim-treesitter"

      -- Install missing parsers
      local already_installed_parsers = ts.get_installed()
      local to_install = vim
        .iter(ensure_installed_parsers)
        :filter(function(parser)
          return not vim.tbl_contains(already_installed_parsers, parser)
        end)
        :totable()
      if #to_install > 0 then
        ts.install(to_install)
      end

      -- Enable treesitter
      vim.api.nvim_create_autocmd("FileType", {
        group = require("core.utils").create_augroup "treesitter",
        desc = "Enable Treesitter highlighting",
        pattern = "*",
        callback = function(ev)
          -- Enable treesitter for all filetypes except bigfile
          if vim.bo[ev.buf].filetype ~= "bigfile" then
            pcall(function()
              vim.treesitter.start()
            end)
          end
        end,
      })

      vim.treesitter.language.register("gotmpl", "template")
      vim.treesitter.language.register("python", "pyn")
      vim.treesitter.language.register("bash", "envfile")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      for _, name in ipairs(ensure_installed_parsers) do
        vim.g["no_" .. name .. "_maps"] = true
      end
    end,
    opts = {
      textobjects = {
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      },
      keymaps = {
        select = {
          ["aa"] = "@assignment.outer",
          ["ab"] = "@block.outer",
          ["ac"] = "@class.outer",
          ["af"] = "@function.outer",
          ["ai"] = "@conditional.outer",
          ["al"] = "@loop.outer",
          ["an"] = "@number.outer",
          ["ap"] = "@parameter.outer",
          ["aC"] = "@comment.outer",

          ["ia"] = "@assignment.inner",
          ["ib"] = "@block.inner",
          ["ic"] = "@class.inner",
          ["if"] = "@function.inner",
          ["ii"] = "@conditional.inner",
          ["il"] = "@loop.inner",
          ["in"] = "@number.inner",
          ["ip"] = "@parameter.inner",
          ["iC"] = "@comment.inner",
        },
        move = {
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]p"] = "@parameter.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]P"] = "@parameter.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[p"] = "@parameter.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[P"] = "@parameter.outer",
            ["[C"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts.textobjects)

      -- Select keymaps
      for key, val in pairs(opts.keymaps.select) do
        vim.keymap.set({ "x", "o" }, key, function()
          require("nvim-treesitter-textobjects.select").select_textobject(val, "textobjects")
        end)
      end

      -- Swap keymaps
      vim.keymap.set("n", "<leader>msp", function()
        require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
      end, { desc = "Swap with next parameter" })
      vim.keymap.set("n", "<leader>msP", function()
        require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.outer"
      end, { desc = "Swap with previous parameter" })

      -- Move keymaps
      for move_type, move_maps in pairs(opts.keymaps.move) do
        for key, textobj in pairs(move_maps) do
          vim.keymap.set({ "n", "x", "o" }, key, function()
            require("nvim-treesitter-textobjects.move")[move_type](textobj, "textobjects")
          end)
        end
      end

      -- Repeatable motions
      local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

      -- Make movement repeatable with ; and .
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

      -- Make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },
}
