if vim.g.neovide then
  vim.o.guifont = "Rec_Mono_Duotone,codicon,nonicons,Symbols_Nerd_Font_Mono:h17"
end

-- Used `core.init` instead of `core` because `nvim-cmp` also has a `core` module
require("core.init"):bootstrap() -- Bootstrap Lazy and start the magic
