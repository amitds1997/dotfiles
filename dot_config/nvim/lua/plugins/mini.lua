local custom_pickers = {
  registry = function()
    local items = vim.tbl_keys(MiniPick.registry)
    table.sort(items)

    local selected = MiniPick.start {
      source = { items = items, name = "Registry" },
    }
    if selected == nil then
      return
    end
    return MiniPick.registry[selected]()
  end,
  zoxide = function()
    local res = MiniPick.builtin.cli({
      command = { "zoxide", "query", "--list" },
    }, {
      source = {
        name = "Zoxide",
        choose = function(item)
          vim.schedule(function()
            require("fff").find_files_in_dir(item)
            vim.fn.chdir(item)
          end)
        end,
      },
    })
    if res == nil then
      return
    end
  end,
  leetcode = function()
    local items = vim.fn.getcompletion("Leet ", "cmdline")

    if vim.tbl_isempty(items) then
      vim.notify("Leetcode is not initialized. Initialize using `:Leet`", vim.log.levels.WARN)
      return
    end

    local res = MiniPick.start {
      source = {
        items = items,
        name = "Leetcode action(s)",
        choose = function(item)
          vim.schedule(function()
            vim.cmd("Leet " .. item)
          end)
        end,
      },
    }

    if res == nil then
      vim.notify("No actions selected", vim.log.levels.WARN)
      return
    end
  end,
}

local function open_buf_in_split(buf_id, key_map, direction)
  local MiniFiles = require "mini.files"

  local function rhs()
    local cur_target = MiniFiles.get_explorer_state().target_window

    -- Noop if explorer isn't open or the cursor is on a directory
    if cur_target == nil or MiniFiles.get_fs_entry().fs_type == "directory" then
      return
    end

    -- Make a new window and set it as target.
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. " split")
      return vim.api.nvim_get_current_win()
    end)
    MiniFiles.set_target_window(new_target)

    -- Go in and close the explorer.
    MiniFiles.go_in { close_on_file = true }
  end

  vim.keymap.set("n", key_map, rhs, { buffer = buf_id, desc = "Split " .. string.sub(direction, 12) })
end

---@module 'lazy'
---@type LazyPluginSpec
return {
  "nvim-mini/mini.nvim",
  event = { "VeryLazy" },
  opts = {
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
    files = {
      mappings = {
        show_help = "?",
        go_in_plus = "<cr>",
        go_out_plus = "-",
      },
      content = {
        filter = function(entry)
          return entry.name ~= ".DS_Store"
        end,
      },
      options = { permanent_delete = false },
    },
    diff = {
      view = {
        style = vim.go.number and "number" or "sign",
        signs = {
          add = "┃",
          change = "┃",
          delete = "_",
        },
      },
      mappings = {
        apply = "gh",
        reset = "gH",
        textobject = "gh",
        goto_first = "[H",
        goto_prev = "[h",
        goto_next = "]h",
        goto_last = "]H",
      },
      options = {
        wrap_goto = false,
      },
    },
    clues = {
      triggers = {
        -- Leader
        { mode = "n", keys = "<leader>" },
        { mode = "x", keys = "<leader>" },
        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        -- Marks
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },
        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        -- Windows
        { mode = "n", keys = "<C-w>" },
        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
        -- Brackets `[` and `]`
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
        { mode = "x", keys = "[" },
        { mode = "x", keys = "]" },
        -- <C-r>
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        -- mini.surround
        { mode = "n", keys = "s" },
      },
      clues = {},
      window = {
        delay = 500,
      },
    },
  },
  config = function(_, opts)
    require("mini.surround").setup()
    -- We let `mini.surround` handle `s`
    vim.keymap.set({ "n", "x" }, "s", "<Nop>")

    require("mini.move").setup(opts.move)
    require("mini.jump").setup()
    require("mini.files").setup(opts.files)

    require("mini.diff").setup(opts.diff)
    require("mini.git").setup()
    require("mini.notify").setup {
      window = {
        winblend = 0,
      },
    }
    require("mini.pick").setup()
    require("mini.extra").setup()
    require("mini.misc").setup()
    require("mini.indentscope").setup {
      symbol = "│",
      draw = {
        animation = require("mini.indentscope").gen_animation.none(),
        predicate = function(scope)
          return not scope.body.is_incomplete
            and not vim.b[0].disable_indent
            and not vim.list_contains(
              require("settings").meta_filetypes,
              vim.api.nvim_get_option_value("filetype", {
                buf = 0,
              })
            )
        end,
      },
      options = {
        try_as_border = true,
      },
    }

    local miniclue = require "mini.clue"
    local clues = {}

    -- Hydra mappings for moving lines
    local move_hydra = {}
    for key, val in pairs(opts.move.mappings) do
      local mode = vim.startswith(key, "line_") and "x" or "n"
      table.insert(move_hydra, { mode = mode, keys = val, postkeys = "<leader>mm" })
    end
    vim.list_extend(clues, move_hydra)

    -- Clues for <leader> mappings
    vim.list_extend(clues, {
      { mode = "n", keys = "<leader>a", desc = "+AI" },
      { mode = "n", keys = "<leader>g", desc = "+Git" },
      { mode = "n", keys = "<leader>d", desc = "+Debugging" },
      { mode = "n", keys = "<leader>l", desc = "+LSP" },
      { mode = "n", keys = "<leader>lc", desc = "+Codelens" },
      { mode = "n", keys = "<leader>m", desc = "+Miscellaneous" },
      { mode = "n", keys = "<leader>p", desc = "+Picker" },
      { mode = "n", keys = "<leader>ph", desc = "+History" },
      { mode = "n", keys = "<leader>t", desc = "+Toggle" },
      { mode = "n", keys = "<leader>w", desc = "+Window" },
      { mode = "n", keys = "<leader>x", desc = "+Diagnostics" },
      { mode = "n", keys = "<leader>mm", desc = "+Move around" },
      { mode = "n", keys = "<leader>ms", desc = "+Swap" },

      { mode = "v", keys = "<leader>m", desc = "+Miscellaneous" },
      { mode = "v", keys = "<leader>mm", desc = "+Move stuff" },
      { mode = "x", keys = "<leader>l", desc = "+LSP" },
    })

    vim.list_extend(clues, opts.clues.clues)
    for _, gen_clue in ipairs {
      miniclue.gen_clues.windows {
        submode_resize = true,
      },
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    } do
      vim.list_extend(clues, gen_clue)
    end
    opts.clues.clues = clues

    require("mini.clue").setup(opts.clues)

    -- Set up custom pickers
    for picker_name, impl in pairs(custom_pickers) do
      require("mini.pick").registry[picker_name] = impl
    end

    local hl_opts = opts.highlights
    hl_opts.highlighters = vim.tbl_extend("force", hl_opts.highlighters, {
      hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
    })
    require("mini.hipatterns").setup(hl_opts)
  end,
  keys = {
    {
      "<leader>we",
      function()
        local bufname = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.fnamemodify(bufname, ":p")

        if path and vim.uv.fs_stat(path) then
          require("mini.files").open(bufname, false)
        else
          require("mini.files").open()
        end
      end,
      desc = "File explorer",
    },
    {
      "<leader>tg",
      function()
        require("mini.diff").toggle(0)
      end,
      desc = "Toggle Git overlay",
    },
    {
      "<leader>pb",
      function()
        vim.cmd "Pick buffers"
      end,
      desc = "Pick buffers",
    },
    {
      "<leader>pf",
      function()
        vim.notify "Use `ff` instead"
      end,
      desc = "Pick files",
    },
    {
      "<leader>pF",
      function()
        vim.cmd "Pick git_files"
      end,
      desc = "Search git-tracked files",
    },
    {
      "<leader>pg",
      function()
        vim.cmd "Pick grep_live"
      end,
      desc = "Search content in all files",
    },
    {
      "<leader>pG",
      function()
        vim.cmd "Pick grep"
      end,
      desc = "Search content in all files",
    },
    {
      "<leader>pp",
      function()
        vim.cmd "Pick registry"
      end,
      desc = "Pick a picker",
    },
    {
      "<leader>pr",
      function()
        vim.cmd "Pick resume"
      end,
      desc = "Resume from the last picker action",
    },
    {
      "<leader>pz",
      function()
        vim.cmd "Pick zoxide"
      end,
      desc = "Pick zoxide-based directory and file",
    },
    -- Histories
    {
      "<leader>phc",
      function()
        vim.cmd "Pick history scope=':'"
      end,
      desc = "Command history",
    },
    {
      "<leader>phs",
      function()
        vim.cmd "Pick history scope='/'"
      end,
      desc = "Search history",
    },
    {
      "<leader>phn",
      function()
        require("mini.notify").show_history()
      end,
      desc = "Notification history",
    },
    {
      "<leader>pl",
      function()
        vim.cmd "Pick leetcode"
      end,
      desc = "Leetcode action(s)",
    },
  },
  init = function()
    vim.g.show_dotfiles = true

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set("n", "g.", function()
          vim.g.show_dotfiles = not vim.g.show_dotfiles
          require("mini.files").refresh {
            content = {
              filter = function(entry)
                return vim.g.show_dotfiles or entry.name:sub(1, 1) ~= "."
              end,
            },
          }
        end, { buffer = buf_id, desc = "Toggle `.`-files" })
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      desc = "Add minifiles split keymaps",
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id
        open_buf_in_split(buf_id, "<C-h>", "topleft vertical")
        open_buf_in_split(buf_id, "<C-j>", "belowright horizontal")
        open_buf_in_split(buf_id, "<C-k>", "topleft horizontal")
        open_buf_in_split(buf_id, "<C-l>", "belowright vertical")
        open_buf_in_split(buf_id, "<C-t>", "tab")
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      desc = "Notify LSPs that a file was renamed",
      pattern = "MiniFilesActionRename",
      callback = function(args)
        local changes = {
          files = {
            {
              oldUri = vim.uri_from_fname(args.data.from),
              newUri = vim.uri_from_fname(args.data.to),
            },
          },
        }
        local will_rename_method, did_rename_method =
          vim.lsp.protocol.Methods.workspace_willRenameFiles, vim.lsp.protocol.Methods.workspace_didRenameFiles
        local clients = vim.lsp.get_clients()
        for _, client in ipairs(clients) do
          if client:supports_method(will_rename_method) then
            local res = client:request_sync(will_rename_method, changes, 1000, 0)
            if res and res.result then
              vim.lsp.util.apply_workspace_edit(res.result, client.offset_encoding)
            end
          end
        end

        for _, client in ipairs(clients) do
          if client:supports_method(did_rename_method) then
            client:notify(did_rename_method, changes)
          end
        end
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesWindowUpdate",
      callback = function(ev)
        local state = MiniFiles.get_explorer_state() or {}

        local win_ids = vim.tbl_map(function(t)
          return t.win_id
        end, state.windows or {})

        local function idx(win_id)
          for i, id in ipairs(win_ids) do
            if id == win_id then
              return i
            end
          end
        end

        local this_win_idx = idx(ev.data.win_id)
        local focused_win_idx = idx(vim.api.nvim_get_current_win())

        -- this_win_idx can be nil sometimes when opening fresh minifiles
        if this_win_idx and focused_win_idx then
          -- idx_offset is 0 for the currently focused window
          local idx_offset = this_win_idx - focused_win_idx

          -- the width of windows based on their distance from the center
          -- i.e. center window is 60, then next over is 20, then the rest are 10.
          -- Can use more resolution if you want like { 60, 30, 20, 15, 10, 5 }
          local widths = { 60, 20, 10 }

          local i = math.abs(idx_offset) + 1 -- because lua is 1-based lol
          local win_config = vim.api.nvim_win_get_config(ev.data.win_id)
          win_config.width = i <= #widths and widths[i] or widths[#widths]

          local offset = 0
          for j = 1, math.abs(idx_offset) do
            local w = widths[j] or widths[#widths]
            -- and an extra +2 each step to account for the border width
            local _offset = 0.5 * (w + win_config.width) + 2
            if idx_offset > 0 then
              offset = offset + _offset
            elseif idx_offset < 0 then
              offset = offset - _offset
            end
          end

          win_config.height = idx_offset == 0 and 25 or 20
          win_config.row = math.floor(0.5 * (vim.o.lines - win_config.height))
          win_config.col = math.floor(0.5 * (vim.o.columns - win_config.width) + offset)
          vim.api.nvim_win_set_config(ev.data.win_id, win_config)
        end
      end,
    })
  end,
}
