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
  lazy = false,
  opts = {
    win = {
      backdrop = 100,
    },
    indent = {
      indent = {
        enabled = false,
      },
      scope = {
        only_current = true,
      },
      chunk = {
        enabled = true,
        char = {
          corner_top = "╭",
          corner_bottom = "╰",
          arrow = "",
        },
        only_current = true,
      },
      animate = {
        easing = "inOutQuad",
      },
      filter = function(buf)
        return vim.g.snacks_indent ~= false
          and vim.b[buf].snacks_indent ~= false
          and vim.tbl_contains(require("settings").meta_filetypes, vim.bo[buf].buftype)
      end,
    },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = {
      enabled = true,
    },
    scratch = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        easing = "inOutQuad",
      },
    },
    picker = {
      enabled = true,
    },
    statuscolumn = { enabled = true, folds = { open = true, git_hl = true } },
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
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
  keys = {
    {
      "<leader>pb",
      function()
        require("snacks").picker.buffers { nofile = false }
      end,
      desc = "Pick buffers",
    },
    {
      "<leader>pf",
      function()
        require("snacks").picker.files {
          hidden = true,
        }
      end,
      desc = "Pick files",
    },
    {
      "<leader>pF",
      function()
        require("snacks").picker.git_files()
      end,
      desc = "Search git-tracked files",
    },
    {
      "<leader>pg",
      function()
        require("snacks").picker.grep()
      end,
      desc = "Search content in all files",
    },
    {
      "<leader>pG",
      function()
        require("snacks").picker.git_grep()
      end,
      desc = "Search content only in git-tracked files",
    },
    {
      "<leader>pp",
      function()
        require("snacks").picker()
      end,
      desc = "Pick picker",
    },
    {
      "<leader>pr",
      function()
        require("snacks").picker.resume()
      end,
      desc = "Resume from the last picker action",
    },
    {
      "<leader>ps",
      function()
        require("snacks").picker.smart()
      end,
      desc = "Smart find files",
    },
    {
      "<leader>pz",
      function()
        require("snacks").picker.zoxide()
      end,
      desc = "Open zoxide-based directory",
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
    -- Extras
    {
      "<leader>eg",
      function()
        require("snacks").lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>ez",
      function()
        require("lazy").home()
      end,
      desc = "Package Manager",
    },
    {
      "<leader>em",
      function()
        vim.cmd "Mason"
      end,
      desc = "Mason",
    },
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

    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        local debug_print = function(...)
          require("snacks").debug.inspect(...)
        end
        vim.print = debug_print
      end,
    })

    -- Use `nvim-web-devicons` for icons in Snacks
    Snacks.util.icon = icon_from_nvim_web_devicons

    Snacks.toggle.inlay_hints():map "<leader>th"
    Snacks.toggle.line_number():map "<leader>tl"
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>tr"
    Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>tw"
    Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>ts"
    Snacks.toggle.diagnostics():map "<leader>td"
    Snacks.toggle.zen():map "<leader>tz"
    Snacks.toggle
      .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
      :map "<leader>tc"
    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>tb"
    vim.keymap.set("n", "<leader>tt", Snacks.terminal.toggle, {
      desc = "Toggle terminal",
    })

    Snacks.toggle
      .new({
        id = "global-autoformat",
        name = "global autoformat",
        get = function()
          return vim.g.autoformat
        end,
        set = function()
          vim.g.autoformat = not vim.g.autoformat
        end,
      })
      :map "<leader>tf"

    -- Toggle codelens
    Snacks.toggle
      .new({
        id = "codelens",
        name = "codelens",
        get = function()
          return vim.g.codelens
        end,
        set = function(state)
          vim.g.codelens = state
          if vim.g.codelens then
            vim.lsp.codelens.refresh()
          else
            vim.lsp.codelens.clear()
          end
        end,
      })
      :map "<leader>tL"
  end,
}
