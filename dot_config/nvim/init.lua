-- Set font for Neovide
if vim.g.neovide then
  vim.o.guifont = "Zed_Mono,Rec_Mono_Duotone,codicon,nonicons,Symbols_Nerd_Font_Mono:h15"
end

-- Used `core.init` instead of `core` because `nvim-cmp` also has a `core` module
require("core.init"):bootstrap()
