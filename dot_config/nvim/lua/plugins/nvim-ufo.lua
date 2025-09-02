local fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
  local new_virt_text = {}
  local suffix = string.format("   %s lines", end_lnum - lnum)
  local suffix_length = vim.fn.strdisplaywidth(suffix)
  local target_width = width - suffix_length
  local curr_width = 0
  for _, chunk in ipairs(virt_text) do
    local chunk_text = chunk[1]
    local chunk_length = vim.fn.strdisplaywidth(chunk_text)
    if target_width > curr_width + chunk_length then
      table.insert(new_virt_text, chunk)
    else
      chunk_text = truncate(chunk_text, target_width - curr_width)
      local hl_group = chunk[2]
      table.insert(new_virt_text, { chunk_text, hl_group })
      chunk_length = vim.fn.strdisplaywidth(chunk_text)
      if curr_width + chunk_length < target_width then
        suffix = suffix .. (" "):rep(target_width - curr_width - chunk_length)
      end
      break
    end
    curr_width = curr_width + chunk_length
  end
  table.insert(new_virt_text, { suffix, "MoreMsg" })
  return new_virt_text
end

---@module 'lazy'
---@type LazyPluginSpec
return {
  "kevinhwang91/nvim-ufo",
  ---@type UfoConfig
  opts = {
    provider_selector = function(_, _, _)
      return { "treesitter", "indent" }
    end,
    close_fold_kinds_for_ft = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      default = { "import", "import_statement", "comment" },
    },
    fold_virt_text_handler = fold_virt_text_handler,
    preview = {
      win_config = {
        winblend = 0,
      },
    },
  },
  event = "BufRead",
  init = function()
    vim.keymap.set("n", "zR", function()
      require("ufo").openAllFolds()
    end, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", function()
      require("ufo").closeAllFolds()
    end, { desc = "Close all folds" })
    vim.keymap.set("n", "zK", function()
      require("ufo").peekFoldedLinesUnderCursor()
    end, { desc = "Peek fold" })
  end,
  dependencies = {
    "kevinhwang91/promise-async",
  },
}
