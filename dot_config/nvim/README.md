# Neovim dot files

My Neovim dot files

## Pending upgrades

### Broken stuff

- [ ] Pyright LSP does not respect `reportUnusedImport = false`
- [ ] GitSigns not working with the default events (Works if lazy loading is off)
- [ ] Setup code folding (also setup mkview and loadview)
- [ ] Setup cursorline correctly (so that I can see where I'm at)
- [ ] Add support for choice nodes in nvim-cmp (or completion menu in general)
- [ ] Sometimes, the folds show the numbers :(
- [ ] Add more support for marks
- [ ] Sometimes the `cmp` window gets left behind :/

### Major upgrades

- [ ] Debugging and test runner setup for Python, Go, Lua, Rust

### Todo

- [ ] Run `remote-nvim.nvim` plenary tests from inside Neovim
- [ ] For `python`, `docker`, the indent line should not span until the new line
- Add keybindings
  - [ ] to find/replace word under cursor
- [ ] Add more treesitter textobjects for movement

### Nice to have

- [ ] Handle disabling mostly everything without having to do `nvim --clean` on
  large files
- [ ] Combine our custom mason installer with either the one offered by a plugin
  or make it more robust / UX friendly
- [ ] Support completions showing up in DAP console

### Refactoring series

- [ ] Re-organize keymaps
- [ ] Add types for completion elements

## TIL

### Wish list

- Vim motions
- Treesitter objects
- Text objects
- All the registers
- Use these more
  - `mini.surround`
  - `mini.ai`
- [ ] CTRL-R in insert and command mode. For help see: `:help i_CTRL-R`
- [ ] `:ju` meaning and how to use it
- [ ] Meshing external commands with buffer content
- [ ] `:h motion.txt` - Built-in motions
- [ ] Explore `<C-W>` and map it to a better combination

### Tips & tricks

- Just do your motion anywhere and it would jump to the next occurrence of the
  motion. For example, `ci[]` in a markdown file would automatically jump to
  the next item that matches the `[]` pattern.

### Registers

- `<backtick>[` - Start of the yanked text
- `<backtick>]` - End of the yanked text

### Commands

- `:r` - read anything into the current buffer. `:r !ls` or `:r <file-name>` into
  file
- `:.!` - insert on the same line

### Textobjects

- `mini.ai`
  - `ii` - object scope
  - `ai` - object scope with border

### Motions

#### Default motions

- `w` - until the start of the next word, EXCLUDING its first character
- `e` - to the end of the current word, INCLUDING the last character
- `0` - to the start of the line
- `^` - to the first non-whitespace character on the line
- `$` - to the end of the line, INCLUDING the last character
- `gg` - to the start of the file
- `G` - to the end of the file
- `<line-number>G` - to the start of the line with number `<line-number>`

#### Other motions

- `mini.ai`
  - `[i` - object scope top border
  - `]i` - object scope bottom border
- `mini.surround`
  - `sa` - add surrounding
  - `sd` - delete surrounding
  - `sr` - replace surrounding
  - `sf` - find surrounding
  - `sh` - highlight surrounding

### Operators

General operation is: `<operator> <count> <motion>`

- `d` - delete operator
- `c` - change operator
- `y` - yank operator

### Shorthands

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
- `z=` - bring up the autocomplete menu
- `g*` and `g#` to match word under cursor with matches that are not full words.
- `CTRL+o` to jump back to the last position of the cursor. `CTRL+i` to move
  forward. Could be helpful when you launch a help window in the same window.
- `'.` to jump to last modified line
- `<backtick>.` to jump to exact position where the last modification was done
- `\_` (in search regex) - span the regex match to multiple lines
- `:se` to track everything that you have changed from the defaults in Neovim
- `:verbose set history` shows where the value was last set from
- `;` - After searching for something using `t`/`T`/`f`/`F`, use `;` to jump to
  the next match
- `gM` - Go to half the length of the text of the line.
- `gm` - Go to half the length of the screen length.
