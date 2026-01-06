local ghostty_config_path = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, "ghostty", "config")

---@module 'lazy'
---@type LazyPluginSpec[]
return {
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
  {
    "bezhermoso/tree-sitter-ghostty", -- Ghostty Treesitter parser
    build = "make nvim_install",
    event = "BufReadPost " .. ghostty_config_path,
    init = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = ghostty_config_path,
        callback = function(event)
          vim.api.nvim_set_option_value("filetype", "ghostty", { buf = event.buf })
        end,
      })
    end,
  },
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    keys = {
      {
        "ff",
        function()
          require("fff").find_files()
        end,
        desc = "FFFind files",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "codecompanion" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      heading = {
        enabled = false,
        position = "overlay",
      },
      latex = { enabled = false },
      sign = { enabled = false },
      overrides = {
        filetype = {
          codecompanion = {
            heading = { enabled = false },
          },
        },
        buftype = {
          nofile = {
            heading = {
              enabled = true,
              position = "inline",
              icons = { "" },
            },
            win_options = {
              concealcursor = {
                rendered = "nc",
              },
            },
          },
        },
      },
    },
  },
}
