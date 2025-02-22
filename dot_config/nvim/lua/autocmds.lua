local create_augroup = require("utils").create_augroup

-- We have a lot of filetypes that just provide meta information related to current context. We
-- prefer to quit them directly using `q` instead of having to do the whole `:q`
vim.api.nvim_create_autocmd("FileType", {
  group = create_augroup "close_with_q",
  pattern = require("settings").meta_filetypes,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Clean up `viewdir` and `undodir` files older than 30 days
vim.api.nvim_create_autocmd({ "FocusLost" }, {
  group = create_augroup "cleanup_old_files",
  once = true,
  callback = function()
    local view_dir = vim.fs.joinpath(vim.fn.stdpath "state", "view")
    local undo_dir = vim.fs.joinpath(vim.fn.stdpath "state", "undo")

    vim.system { "find", view_dir, "-mtime", "+30d", "-delete" }
    vim.system { "find", undo_dir, "-mtime", "+30d", "-delete" }
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = create_augroup "yank_highlight",
  desc = "Highlight text on being yanked",
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      priority = 250,
    }
  end,
})

-- LSP Progress
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
