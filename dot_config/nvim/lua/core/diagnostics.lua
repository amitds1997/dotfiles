local severity_icons = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.INFO] = " ",
  [vim.diagnostic.severity.HINT] = " ",
}

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = severity_icons,
  },
  virtual_text = {
    spacing = 2,
    source = false,
    hl_mode = "blend",
    format = function(diagnostic)
      return diagnostic.message
    end,
    prefix = function(diagnostic, i, _)
      if i == 1 then
        return severity_icons[diagnostic.severity]
      end
      return ""
    end,
  },
})
