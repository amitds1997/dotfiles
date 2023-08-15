return {
  ["<leader>d"] = {
    name = "+diagnostic",

    o = { vim.diagnostic.open_float, "Open diagnostic window" },
    ["]"] = { vim.diagnostic.goto_next, "Go to next diagnostic" },
    ["["] = { vim.diagnostic.goto_prev, "Go to previous diagnostic" },
    l = { vim.diagnostic.setloclist, "Add buffer diagnostics to loclist" },
    q = { vim.diagnostic.setqflist, "Add all diagnostics to quicklist" },
  }
}
