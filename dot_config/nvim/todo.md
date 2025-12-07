# To-do list

## Pending

### Needs to be worked on upstream

- Replace `nvim-autopairs` with `blink.pairs`
- Fix the twitch in the completion menu where responses keep altering b/w
  different answers (needs reproduction) happens because of Copilot most likely
- Set up a nice "winbar" to show file name and current status
- Add shorter when statusline is very compressed (should wait for it to happen)
- Move to newer nvim-treesitter implementation once
  `nvim-treesitter-textobjects` supports it. See
  [nvim-treesitter-textobjects#772].
- Set up better formatting for hover documents (if possible)

### Need an actual use case before implementing it

- [code-companion#mini-diff-setup] with `CodeCompanion` (see also:
  [code-companion#diff-setup]). Adjust `Inline assistant` portion of the
  configuration.
- `mcphub.nvim` (Do we need `vectorcode`?)
- Revisit installing `overseer` for `preLaunchTask` and `postDebugTask`
- Copilot (currently disabled by default)
  - Non-deterministic when it's running and when it's not
  - Fix if the toggle from the statusline does not work
- Visit [codecompanion.nvim#announcements] when all's done

### Plugins

- A nice LSP overview
- Add handler for opening plugin page from their name using `gx`
- More compiler and quickfix-loclist usecases
- Here's how my AI workflow should work:
  - NES
  - Control things through a chat
  - ~In `blink.cmp`'s menu~
- Investigate if we need to set up sessions in Neovim

[nvim-treesitter-textobjects#772]:
  https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/772
[code-companion#mini-diff-setup]:
  https://codecompanion.olimorris.dev/installation.html#mini-diff
[code-companion#diff-setup]:
  https://codecompanion.olimorris.dev/configuration/chat-buffer.html#diff
[codecompanion.nvim#announcements]:
  https://github.com/olimorris/codecompanion.nvim/discussions/categories/announcements
