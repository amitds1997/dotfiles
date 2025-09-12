# To-do list

## Completed

- Slow `:e <large-file>` performance — optimize like `nvim <file>` path
- Not worth the effort
- `conceallevel` is broken for JSON files — fix the associated autocmd
- This was because of the delayed `autocmd` which set `conceallevel` back to `2`
- Completion setup done
- Fix completion keymaps
- Fix auto-surround on completion (e.g., brackets/quotes)
- Add toggle to codeLens and turn it `off` by default
- Fix LSP and verify `checkhealth lsp`
- Add LSP-specific keymappings
- LSP setup
- `bashls`
- `jsonls`
- `yamlls`
- `lua_ls`
- `rust_analyzer`
- `gopls`
- `basedpyright`
- `ruff`
- Add common keymaps for windows
- Fix diagnostics
- Keymaps
- Different float levels and previews in quickfix list
- Remove cSpell. Adds too much noise
- Add `lazygit` shortcut
- Add `snacks.toggle` keymaps
- Setup `snacks.terminal`
- Setup `snacks.pickers`
- Reduce boiler plate to attach LSP. Compare with `vim.lsp.config` and how that
  can help.
- Better split separation. Right now, I don't where one ends and other starts
- Set up Debugger for Python
- Plugins
- `blink.cmp`
- `mini.move`
- `force-cul.nvim`
- `kitty-scrollback.nvim`
- `nvim-autopairs` (also checkout `blink.pairs`)
- `nvim-ufo.nvim`
- `quicker.nvim`
- `snacks.nvim`
- `tiny-code-action`
- `SchemaStore`
- `gitsigns`
- Use `mini.move` to move blocks up/down/left/right in visual selection mode
- Find out how to get files to remember custom folds done earlier
- Check what colorschemes work with transparent/not-transparent and mark it
- Replace `nvim-dap-ui` with `nvim-dap-view`
- Set up copilot
- Replace `gitsigns.nvim` with `mini.diff` and `mini.git`
- Completed statusline
  - Add `AI` badge if it is active, optionally allow disabling/enabling by
    clicking on it
  - Make sure recording macros are shown and supported
  - Add git status + LSP to statusline
- Hydra mode for debugging keymaps (similar to `miroshQa/debugmaster.nvim`)
- Replaced
  - `snacks.nvim` with `mini.pick`
- Evaluate:
  - `MariaSolOs/dotfiles`
  - `ofseed/nvim`
  - `glepnir/nvim`
  - `jdhao/nvim-config`
  - `olimorris/dotfiles`
  - `idr4n/nvim-lua`
- Ensure debug bar is visible in the UI
- Automatically pick up correct Python virtual environment (for both LSP &
  Debug)
- Add formatter for Markdown to split lines at the right spot
- Enable `f-string` using `basedpyright` LSP
- Figure out way to jump LSP + Treesitter contexts better
- Jump to start and end of methods/functions
- Swap arguments/parameters
- Setup incremental selection via `nvim-treesitter`

## Pending

### Needs to be worked on upstream

- Replace `nvim-autopairs` with `blink.pairs`
- Fix the twitch in the completion menu where responses keep altering b/w
  different answers (needs reproduction) happens because of Copilot most likely
- Set up a nice "winbar" to show file name and current status
- Remove magical white spaces from markdown concealed when
  [neovim#conceal-text-bug] is fixed
- Add shorter when statusline is very compressed (should wait for it to happen)
- Move to newer nvim-treesitter implementation once
  `nvim-treesitter-textobjects` supports it. See
  [nvim-treesitter-textobjects#772].

### Need an actual use case before implementing it

- [code-companion#mini-diff-setup] with `CodeCompanion` (see also:
  [code-companion#diff-setup]). Adjust `Inline assistant` portion of the
  configuration.
- `mcphub.nvim` (Do we need `vectorcode`?)
- Investigate `:compiler` with `:make` for different filetypes
- Investigate if we need to set up sessions in Neovim
- Revisit installing `overseer` for `preLaunchTask` and `postDebugTask`

### Plugins

- Plugins to remove:
  - `lazydev.nvim`

### Miscellaneous

- Copilot (currently disabled by default)
  - Non-deterministic when it's running and when it's not
  - Fix if the toggle from the statusline does not work
- Visit [codecompanion.nvim#announcements] when all's done
- We want a top bar just like `nixCats` and maybe the bottom bar as well

[nvim-treesitter-textobjects#772]:
  https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/772
[code-companion#mini-diff-setup]:
  https://codecompanion.olimorris.dev/installation.html#mini-diff
[code-companion#diff-setup]:
  https://codecompanion.olimorris.dev/configuration/chat-buffer.html#diff
[neovim#conceal-text-bug]: https://github.com/neovim/neovim/issues/14409
[codecompanion.nvim#announcements]:
  https://github.com/olimorris/codecompanion.nvim/discussions/categories/announcements
