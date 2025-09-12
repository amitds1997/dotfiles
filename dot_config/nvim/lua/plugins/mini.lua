-- selene: allow(undefined_variable)

-- TODO: Build pickers for undo
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
  dependencies = { { "mskelton/termicons.nvim", build = false } },
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
  },
  config = function(_, opts)
    local surround_opts = opts.surround

    require("mini.surround").setup(surround_opts)
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

    -- Schedule highlight groups to be applied when possible
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = function()
        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { link = "SnacksIndentChunk", force = true })
      end,
    })

    -- Set up custom pickers
    for picker_name, impl in pairs(custom_pickers) do
      require("mini.pick").registry[picker_name] = impl
    end

    -- Use `mini.pick` for `vim.ui.select`
    vim.ui.select = require("mini.pick").ui_select

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
  -- TODO: Add keymap for git blame toggle
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
        require("mini.diff").toggle_overlay(0)
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
  end,
}
