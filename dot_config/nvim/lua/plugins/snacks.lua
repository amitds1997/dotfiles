--- Get an icon from `nvim-web-devicons`.
local function icon_from_nvim_web_devicons(name, cat, opts)
  opts = opts or {}
  opts.fallback = opts.fallback or {}
  if cat == "directory" then
    return opts.fallback.dir or "󰉋 ", "Directory"
  end
  local Icons = require "nvim-web-devicons"
  local icon, hl ---@type string?, string?
  if cat == "filetype" then
    icon, hl = Icons.get_icon_by_filetype(name, { default = false })
  elseif cat == "file" then
    local ext = name:match "%.(%w+)$"
    icon, hl = Icons.get_icon(name, ext, { default = false })
  elseif cat == "extension" then
    icon, hl = Icons.get_icon(nil, name, { default = false })
  end
  if icon then
    return icon, hl
  end
  return opts.fallback.file or " "
end

---@module 'lazy'
---@type LazyPluginSpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  enabled = true,
  lazy = false,
  opts = {
    -- indent = {
    --   indent = {
    --     enabled = false,
    --   },
    --   scope = {
    --     only_current = true,
    --   },
    --   chunk = {
    --     enabled = true,
    --     char = {
    --       corner_top = "╭",
    --       corner_bottom = "╰",
    --       arrow = "",
    --     },
    --     only_current = true,
    --   },
    --   animate = {
    --     easing = "inOutQuad",
    --   },
    --   filter = function(buf)
    --     return vim.g.snacks_indent ~= false
    --       and vim.b[buf].snacks_indent ~= false
    --       and vim.tbl_contains(require("settings").meta_filetypes, vim.bo[buf].buftype)
    --   end,
    -- },
    statuscolumn = { enabled = false, folds = { open = true, git_hl = true } },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
  keys = {
    -- {
    --   "<leader>pb",
    --   function()
    --     require("snacks").picker.buffers { nofile = false }
    --   end,
    --   desc = "Pick buffers",
    -- },
    -- {
    --   "<leader>pf",
    --   function()
    --     require("snacks").picker.files {
    --       hidden = true,
    --     }
    --   end,
    --   desc = "Pick files",
    -- },
    -- {
    --   "<leader>pF",
    --   function()
    --     require("snacks").picker.git_files()
    --   end,
    --   desc = "Search git-tracked files",
    -- },
    -- {
    --   "<leader>pg",
    --   function()
    --     require("snacks").picker.grep()
    --   end,
    --   desc = "Search content in all files",
    -- },
    -- {
    --   "<leader>pG",
    --   function()
    --     require("snacks").picker.git_grep()
    --   end,
    --   desc = "Search content only in git-tracked files",
    -- },
    -- {
    --   "<leader>pp",
    --   function()
    --     require("snacks").picker()
    --   end,
    --   desc = "Pick picker",
    -- },
    -- {
    --   "<leader>pr",
    --   function()
    --     require("snacks").picker.resume()
    --   end,
    --   desc = "Resume from the last picker action",
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
    --   "<leader>phc",
    --   function()
    --     require("snacks").picker.command_history()
    --   end,
    --   desc = "Command history",
    -- },
    -- {
    --   "<leader>phs",
    --   function()
    --     require("snacks").picker.search_history()
    --   end,
    --   desc = "Search history",
    -- },
    -- {
    --   "<leader>phn",
    --   function()
    --     require("snacks").notifier.show_history()
    --   end,
    --   desc = "Notification history",
    -- },
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
  init = function()
    local Snacks = require "snacks"

    -- Use `nvim-web-devicons` for icons in Snacks
    Snacks.util.icon = icon_from_nvim_web_devicons
  end,
}
