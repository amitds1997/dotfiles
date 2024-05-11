if vim.g.neovide then
  vim.o.guifont = "Rec_Mono_Duotone,codicon,nonicons,Symbols_Nerd_Font_Mono:h17"
end

require("core"):bootstrap() -- Bootstrap Lazy and start the magic
