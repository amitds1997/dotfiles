local ts_parsers = {
  "bash",
  "c",
  "comment",
  "cpp",
  "css",
  "csv",
  "diff",
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
  "jsonc",
  "just",
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
  "ssh_config",
  "terraform",
  "toml",
  "typescript",
  "vimdoc",
  "xml",
  "yaml",
}

---@module 'lazy'
---@type LazyPluginSpec
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile", "CmdlineEnter" },
  build = ":TSUpdate",
  version = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        max_lines = 3,
        multiline_threshold = 1,
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
  opts = {
    ensure_installed = ts_parsers,
    highlight = {
      enable = true,
      disable = function(_, bufnr)
        return vim.bo[bufnr].filetype == "bigfile"
      end,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
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
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>msp"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>msP"] = "@parameter.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
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
    require("nvim-treesitter.configs").setup(opts)

    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

    -- Make movement repeatable with ; and .
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    vim.treesitter.language.register("gotmpl", "template")
    vim.treesitter.language.register("python", "pyn")
    vim.treesitter.language.register("bash", "envfile")
  end,
}
