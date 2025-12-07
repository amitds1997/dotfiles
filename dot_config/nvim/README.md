# Neovim configuration

## TIL keymaps

- `[q`, `]q`, `[Q`, `]Q`, `[CTRL-Q`, `]CTRL-Q` navigate through the quickfix
  list
- `[l`, `]l`, `[L`, `]L`, `[CTRL-L`, `]CTRL-L` navigate through the location
  list
- `[t`, `]t`, `[T`, `]T`, `[CTRL-T`, `]CTRL-T` navigate through the tag match
  list
- `[a`, `]a`, `[A`, `]A` navigate through the argument list
- `[b`, `]b`, `[B`, `]B` navigate through the buffer list
- `[<Space>`, `]<Space>` to create space above/below cursor
- `<C-a>`/`<C-x>` to increment/decrement numbers
- Use move lines operations more when faster
- Use surround operations more
- Use forward and backward searching options more using `mini.jump`
- Use `<C-\><C-n>` to jump to buffer mode in terminal buffer

## Confirmed plugins

These list down plugins which I think is not worth replacing with other plugins
or rewriting it on my own to reduce plugin count.

1. `nvim-autopairs` (no `mini.pairs` for me)
2. `mini.surround` for surrounding
3. `mini.move` for moving lines around

## AI features

1. Set up agent-mode and ask-mode chat
2. Set up automatically attaching the current line and buffer into the context.
3. How to ensure that the buffer stays to the side and is not messed with.
4. Set up diff-workflow accept/reject workflow for changes made by the AI
5. Set up next edit suggestion aka NES
6. Add more prompt categories for the chat

## Things that I need Neovim to be good at

- Neovim motions
- Faster navigation, search and replace
- LSP, DAP and Diagnostics
- Auto-completion working everywhere (including DAP, filepaths)
- AI support (both enable and quick-disable)
- Syntax-based highlighting and navigation
- Excellent git support in the limited space available

### Jot down

- `Agent mode` can roughly be achieved using Codecompanion.nvim plugin by just
  adding the `insert_edit_into_file` tool to the chat. Not sure if it would be
  able to edit multiple files yet though.
- `Edit mode` can be achieved using `insert_edit_into_file` tool
- I would like the current active buffer and selected lines to always be
  attached to the chat buffer
- Can this be done dynamically?
