# To do

- [ ] Fix completion keymaps
- [ ] Fix auto-surround completion

## VS Code features

- Single command to switch to your Neovim configuration without leaving Neovim. _If possible, should automatically get
  applied on getting saved_

## Development philosophy

Once you start working on any file:

- Treesitter should attach to the buffer automatically, if parser is available
- If LSP is available, should attach to the buffer
- Formatter should handle auto-formatting for available buffers
