vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = require("core.constants").severity_icons,
  },
  virtual_text = false,
  -- virtual_text = {
  --   source = false,
  --   prefix = "",
  -- },
})
