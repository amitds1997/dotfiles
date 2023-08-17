return {
  ["<leader>d"] = {
    name = "+diagnostic",

    w = { function () require("trouble").open("workspace_diagnostics") end, "Open workspace diagnostics" },
    d = { function () require("trouble").open("document_diagnostics") end, "Open document diagnostics" },
    l = { function () require("trouble").open("loclist") end, "Open loclist" },
    q = { function () require("trouble").open("quickfix") end, "Open quickfix" },
    ["]"] = { vim.diagnostic.goto_next, "Go to next diagnostic" },
    ["["] = { vim.diagnostic.goto_prev, "Go to previous diagnostic" },

    a = {
      name = "+diagnostic-add",

      l = { vim.diagnostic.setloclist, "Add buffer diagnostics to loclist" },
      q = { vim.diagnostic.setqflist, "Add all diagnostics to quicklist" },
    }
  }
}
