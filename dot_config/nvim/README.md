# Neovim configuration

## TIL keymaps

- `[q`, `]q`, `[Q`, `]Q`, `[CTRL-Q`, `]CTRL-Q` navigate through the quickfix list
- `[l`, `]l`, `[L`, `]L`, `[CTRL-L`, `]CTRL-L` navigate through the location list
- `[t`, `]t`, `[T`, `]T`, `[CTRL-T`, `]CTRL-T` navigate through the tag match list
- `[a`, `]a`, `[A`, `]A` navigate through the argument list
- `[b`, `]b`, `[B`, `]B` navigate through the buffer list
- `[<Space>`, `]<Space>` to create space above/below cursor
- `<C-a>`/`<C-x>` to increment/decrement numbers
- Use move lines operations more when faster
- Use surround operations more
- Use forward and backward searching options more using `mini.jump`

## Confirmed plugins

These list down plugins which I think is not worth replacing with other plugins
or rewriting it on my own to reduce plugin count.

1. `nvim-autopairs` (no `mini.pairs` for me)
2. `mini.surround` for surrounding
3. `mini.move` for moving lines around
