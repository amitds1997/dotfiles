local T = require "utils.toggler.toggler"

function T.inlay_hints()
  return T.new {
    id = "inlay_hints",
    name = "Inlay hints",
    get = function()
      return vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
    end,
    set = function(state)
      vim.lsp.inlay_hint.enable(state, { bufnr = 0 })
    end,
    notify = true,
  }
end

function T.diagnostics()
  return T.new {
    id = "diagnostics",
    name = "Diagnostics",
    get = function()
      return vim.diagnostic.is_enabled { bufnr = 0 }
    end,
    set = function(state)
      vim.diagnostic.enable(state, { bufnr = 0 })
    end,
    notify = true,
  }
end

return T
