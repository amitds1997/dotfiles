# Neovim dot files

My Neovim dot files

## Tips & tricks

- Just do your motion anywhere and it would jump to the next occurrence of the
  motion. For example, `ci[]` in a markdown file would automatically jump to
  the next item that matches the `[]` pattern.

## Registers

- `<backtick>[` - Start of the yanked text
- `<backtick>]` - End of the yanked text

## Modes

`v` - visual character mode
`V` - visual line mode

## Commands

`r` - read anything into the current buffer. `:r !ls` or `:r <file-name>` into file

## Textobjects

- `mini.ai`
  - `ii` - object scope
  - `ai` - object scope with border

## Motions

### Default motions

- `w` - until the start of the next word, EXCLUDING its first character
- `e` - to the end of the current word, INCLUDING the last character
- `0` - to the start of the line
- `^` - to the first non-whitespace character on the line
- `$` - to the end of the line, INCLUDING the last character
- `gg` - to the start of the file
- `G` - to the end of the file
- `<line-number>G` - to the start of the line with number `<line-number>`

### Other motions

- `mini.ai`
  - `[i` - object scope top border
  - `]i` - object scope bottom border
- `mini.surround`
  - `sa` - add surrounding
  - `sd` - delete surrounding
  - `sr` - replace surrounding
  - `sf` - find surrounding
  - `sh` - highlight surrounding

## Operators

General operation is: `<operator> <count> <motion>`

- `d` - delete operator
- `c` - change operator
- `y` - yank operator

## Shorthands

- `C` for `c$` - Change till end of line
- `<count>CTRL-A` - Add `[count]` to the number or alphabetic character at
  or after the cursor
- `CTRL-g` - Show location in the file
- `U` - Undo all the latest changes on a line
- `u` - Undo one change
- `p` - Paste after the cursor
- `P` - Paste before the cursor
- `<C-r>` - Repeat the latest undo
- `r<char>` - replace character under cursor with `<char>`
- Enter into insert mode
  - `a` - append after the cursor
  - `i` - insert before the cursor
  - `A` - append at the end of the line
  - `I` - insert at the beginning of the line
- `R` - Enter replace mode
- `CTRL-O` - Execute one command, return to Insert mode (but has it's own quirks)
