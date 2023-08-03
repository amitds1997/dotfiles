local remote_nvim = function ()
  require("remote-nvim").setup({})
end

return {
  "amitds1997/remote-nvim.nvim",
  config = remote_nvim,
  cmd = "Test",
  dev = true,
}
