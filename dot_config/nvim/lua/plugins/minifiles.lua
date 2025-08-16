local show_dotfiles = true

local filter_show = function()
  return true
end

local filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end

local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  require("mini.files").refresh { content = { filter = new_filter } }
end

local function map_split(buf_id, lhs, direction)
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

  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = "Split " .. string.sub(direction, 12) })
end

local function compare_alphanumerically(e1, e2)
  -- Put directories first.
  if e1.is_dir ~= e2.is_dir then
    return e1.is_dir
  end

  -- Order numerically based on digits if the text before them is equal.
  if e1.pre_digits == e2.pre_digits and e1.digits and e2.digits then
    return e1.digits < e2.digits
  end

  -- Otherwise order alphabetically ignoring case.
  return e1.lower_name < e2.lower_name
end

---@module 'lazy'
---@type LazyPluginSpec
return {
  "echasnovski/mini.files",
  lazy = true,
  keys = {
    {
      "<leader>we",
      function()
        local bufname = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.fnamemodify(bufname, ":p")

        if path and vim.uv.fs_stat(path) then
          require("mini.files").open(bufname, false)
        end
      end,
      desc = "File explorer",
    },
  },
  opts = {
    mappings = {
      show_help = "?",
      go_in_plus = "<cr>",
      go_out_plus = "-",
    },
    content = {
      filter = function(entry)
        return entry.fs_type ~= "file" or entry.name ~= ".DS_Store"
      end,
      sort = function(entries)
        local sorted = vim.tbl_map(function(entry)
          local pre_digits, digits = entry.name:match "^(%D*)(%d+)"
          if digits ~= nil then
            digits = tonumber(digits)
          end

          return {
            fs_type = entry.fs_type,
            name = entry.name,
            path = entry.path,
            lower_name = entry.name:lower(),
            is_dir = entry.fs_type == "directory",
            pre_digits = pre_digits,
            digits = digits,
          }
        end, entries)

        table.sort(sorted, compare_alphanumerically)

        -- Keep only the necessary fields.
        return vim.tbl_map(function(x)
          return { name = x.name, fs_type = x.fs_type, path = x.path }
        end, sorted)
      end,
    },
    options = { permanent_delete = false },
  },
  config = function(_, opts)
    local minifiles = require "mini.files"
    minifiles.setup(opts)

    vim.api.nvim_create_autocmd("User", {
      desc = "Add minifiles split keymaps",
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id
        map_split(buf_id, "<C-h>", "topleft vertical")
        map_split(buf_id, "<C-j>", "belowright horizontal")
        map_split(buf_id, "<C-k>", "topleft horizontal")
        map_split(buf_id, "<C-l>", "belowright vertical")
        map_split(buf_id, "<C-t>", "tab")
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle `.`-files" })
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
