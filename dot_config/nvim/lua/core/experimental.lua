if vim.version.gt(vim.version(), { 0, 11, 0 }) then
  require("vim._extui").enable {
    msg = {
      target = "cmd",
      timeout = 2000,
    },
  }
end
