# Neovim configuration

## Tasks

1. Agent MCP solution.
   - It should work in some form with Copilot, Claude Code, Open Code and Gemini
     CLI
   - Better highlighting and granular change selection with the solution
   - Ask mode for project
   - Ensure that the buffer stays to the side and is not messed with.
2. Add AGENTS/SKILLS in repos
   - Verify PR before getting it ready for review
3. `mini.files` - Do not show or grey out the gitignored directories
4. Improve `hover` configuration. I want a split window or something that auto
   closes and also does not live in the buffer window
5. Create LSP overview window. Supported actions:
   - LSP overview
   - Ability to stop/start them (maybe a picker could also work)
6. Integrate showing filename in the left side of the buffer
7. For LSP, just show an icon that shows that LSPs are attached. The overview
   window will work fine for the rest of the scenarios
8. Add supported and work-approved MCPs to the AI tool. See, memory tools
9. Improve NES in Neovim

### Extras

- Visit [code-companion-announcements] when all's done
- Revisit installing `overseer` for `preLaunchTask` and `postDebugTask`
- Add handler for opening plugin page from their name using `gx`

## Things that I need Neovim to be good at

- Neovim motions
- Faster navigation, search and replace
- LSP, DAP and Diagnostics
- Auto-completion working everywhere (including DAP, filepaths)
- Syntax-based highlighting and navigation
- Excellent git support in the limited space available

## TIL

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

[code-companion-announcements]:
  https://github.com/olimorris/codecompanion.nvim/discussions/categories/announcements
