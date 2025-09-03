local set = require("core.utils").set_keymap
local Toggler = require "utils.toggler"

set("<TAB>", "<cmd>bnext<CR>", "Switch buffers (next)")
set("<S-TAB>", "<cmd>bprevious<CR>", "Switch buffers (next)")

set("<leader>mn", function()
  require("snacks").notifier.hide()
end, "Hide active notifications")

-- Window keymaps
set("<C-h>", "<cmd>wincmd h<CR>", "Move to window towards left")
set("<C-j>", "<cmd>wincmd j<CR>", "Move to window towards bottom")
set("<C-k>", "<cmd>wincmd k<CR>", "Move to window towards top")
set("<C-l>", "<cmd>wincmd l<CR>", "Move to window towards right")

set("<leader>wq", "<cmd>close<CR>", "Close active window")
set("<leader>wo", "<cmd>only<CR>", "Close all except active window")

-- Make `U` opposite of `u`
set("U", "<C-r>", "Redo changes")

-- Handle search highlighting using <Esc>
vim.keymap.set({ "n", "v", "i" }, "<Esc>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd "nohlsearch"
  end
  return "<Esc>"
end, { expr = true, silent = true })

set("z=", function()
  require("mini.extra").pickers.spellsuggest()
end, "Suggest spelling corrections")

-- Handle delmarks
set("<leader>md", function()
  local arg = vim.fn.input "Which marks do you want to delete? "
  if arg ~= "" then
    vim.cmd("delmarks " .. arg .. " | redraw!")
  end
end, "Delete marks")

-- Handle maximizing float windows
set("<leader>tz", function()
  require("mini.misc").zoom(0, {
    title = vim.api.nvim_buf_get_name(0),
  })
end, "Toggle zoom for buffer")

-- Launch a terminal
set("<leader>tt", function()
  require("utils").float_term()
end, "Toggle terminal")

-- Launch LazyGit
set("<leader>g", function()
  local opts = {
    title = "Lazygit",
    title_pos = "center",
  }

  local cwd = (require("mini.git").get_buf_data(0) or {}).root
  if cwd ~= nil then
    opts["cwd"] = cwd
  end

  require("utils").float_term("lazygit", opts)
end, "Launch Lazygit")

-- Launch Lazy
set("<leader>z", function()
  vim.cmd "Lazy"
end, "Launch Lazy")

-- Launch Mason
set("<leader>em", function()
  vim.cmd "Mason"
end, "Launch Mason")

-- Set toggle options
Toggler.inlay_hints():map "<leader>th"
Toggler.diagnostics():map "<leader>tx"
Toggler.option("number", { name = "line number" }):map "<leader>tl"
Toggler.option("relativenumber", { name = "relative number" }):map "<leader>tr"
Toggler.option("wrap", { name = "wrap" }):map "<leader>tw"
Toggler.option("spell", { name = "spelling" }):map "<leader>ts"
Toggler.option(
  "conceallevel",
  ---@diagnostic disable-next-line: undefined-field
  { off = 0, on = 2 }
):map "<leader>tc"
Toggler.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>tb"

-- Toggle copilot
vim.g.copilot_enabled = true
Toggler.new({
  id = "global-copilot",
  name = "Copilot",
  get = function()
    return vim.g.copilot_enabled
  end,
  set = function()
    vim.g.copilot_enabled = not vim.g.copilot_enabled
  end,
  notify = true,
}):map "<leader>ta"

-- Toggle autoformat
Toggler.new({
  id = "global-autoformat",
  name = "global autoformat",
  get = function()
    return vim.g.autoformat
  end,
  set = function()
    vim.g.autoformat = not vim.g.autoformat
  end,
  notify = true,
}):map "<leader>tf"

-- Toggle codelens
Toggler.new({
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
  notify = true,
}):map "<leader>tL"
