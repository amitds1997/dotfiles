---@module 'lazy'
---@type LazyPluginSpec
return {
  "echasnovski/mini.nvim",
  lazy = false,
  opts = {
    surround = {
      ft_custom_surroundings = {
        markdown = {
          B = {
            input = { "%*%*().-()%*%*" },
            output = { left = "**", right = "**" },
          },
          I = {
            input = { "%_().-()%_" },
            output = { left = "_", right = "_" },
          },
          M = {
            input = { "%`().-()%`" },
            output = { left = "`", right = "`" },
          },
        },
      },
    },
    move = {
      mappings = {
        left = "<leader>mmh",
        right = "<leader>mml",
        down = "<leader>mmj",
        up = "<leader>mmk",

        line_left = "<leader>mmh",
        line_right = "<leader>mml",
        line_down = "<leader>mmj",
        line_up = "<leader>mmk",
      },
      options = {
        reindent_linewise = false,
      },
    },
    highlights = {
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      },
    },
  },
  config = function(_, opts)
    local surround_opts = opts.surround

    require("mini.surround").setup(surround_opts)
    require("mini.move").setup(opts.move)
    require("mini.jump").setup()

    local hl_opts = opts.highlights
    hl_opts.highlighters = vim.tbl_extend("force", hl_opts.highlighters, {
      hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
    })
    require("mini.hipatterns").setup(hl_opts)

    -- Setup filetype-specific surrounds
    vim.api.nvim_create_autocmd("FileType", {
      group = require("core.utils").create_augroup "mini-surround-custom",
      desc = "Setup filetype specific custom surroudings",
      callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        vim.b.minisurround_config = {
          custom_surroundings = surround_opts.ft_custom_surroundings[ft],
        }
      end,
    })
  end,
  keys = {
    {
      "<leader>hm",
      function()
        require("which-key").show {
          keys = "<leader>mm",
          loop = true,
        }
      end,
      desc = "Move line/selection",
      mode = { "n", "x", "v" },
    },
  },
}
