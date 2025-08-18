# TODO

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
- Reduce boiler plate to attach LSP. Compare with `vim.lsp.config` and how
  that can help.
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
- `which-key.nvim`
- `SchemaStore`
- `gitsigns`
- Use `mini.move` to move blocks up/down/left/right in visual selection mode
- Find out how to get files to remember custom folds done earlier
- Check what colorschemes work with transparent/not-transparent and mark it
- Replace `nvim-dap-ui` with `nvim-dap-view`
- Set up copilot

## Needs external work/help

- Replace `nvim-autopairs` with `blink.pairs`
- Hack added to [which-key](./lua/plugins/which-key.lua) until this is fixed: [which-key#issue][6]
- In `mini.files`, git-ignored files should be shown but grayed out more than
  the rest.
- Fix the twitch in the completion menu where responses keep altering b/w
  different answers (needs reproduction)
- Set up a nice "winbar" to show file name and current status
- Remove magical white spaces from markdown concealed when [this][5] is fixed

## Future Tasks

- Replace `gitsigns.nvim` with `mini.diff` and `mini.git`
- Complete statusline
  - Add shorter when statusline is very compressed
  - Better file name and path along with status. Except the file name, [dim the rest of the path][2]
  - Add `git` info (Can we do it [at the top][1] along with file name? Or maybe at the rightmost spot on statusline?)
  - Add `AI` badge if it is active, optionally allow disabling/enabling it using
    that
  - Make all colors be determined by the mode kind of like [this][7]
  - Make sure recording macros are shown and supported
  - Read through this guide on building a statusline: [Guide][11]
  - Evaluate [idr4n/nvim-lua][9] and [this][8], and [this][10] and obviously [NvChad][12] statusline organization

```text
[[<greyed-path>/<filename> <status>][E<n>W<n>H<n>][LSP]] ============= [[line-position][AI][git-branch][mode]]
```

- Evaluate `MariaSolOs/dotfiles`, `ofseed/nvim`, `glepnir/nvim`, `jdhao/nvim-config`,
  `olimorris/dotfiles`, `idr4n/nvim-lua` for ideas & plugin setups
- Figure out way to jump LSP + Treesitter contexts better
- Swap arguments/parameters
- Jump to start+end of methods and functions
- Setup incremental selection via `nvim-treesitter`
- Plugins
  - `mini.ai`
- Should we replace `which-key` with `mini.clue`
- Add git status + LSP to statusline
- Set up sessions in Neovim. Set `sessionoptions` (see LazyVim)
- Improve the `diffview` seen in `lazygit`
- Debugging
  - Revisit if we want to install `overseer` to run `preLaunchTask` and `postDebugTask`
  - Use better shortcuts like `fn` keys when debugging
  - Make sure that the debug bar is visible through the UI
- Automatically pick up the correct virtual environment in Python (for both LSP+Debug)
- Add toggle for copilot
- List of plugins I hope to get rid of:
  - `lazydev.nvim`
  - `plenary.nvim`
  - `render-markdown.nvim`
  - `which-key.nvim`
- [Mini-diff][3] integration with `CodeCompanion`. Also see: [diff][4]. Also
  adjust `Inline assistant` portion of the configuration.
- Setup `mcphub.nvim`. Do we need `vectorcode`?
- Replace `snacks.nvim` with `mini.pick`
- Integrate `:compiler` with `:make` for different filetypes
- Fix `terminal` and normal buffer easy switching
- Fix Copilot not starting correctly at all times? In a buffer where it's running,
  run `Copilot disable` followed by enable and it would still not show up :(
- Add formatter for markdown that takes care of splitting lines at the right spot
- Might we be interested in toggling breadcrumbs in the statusline?

[1]: https://www.reddit.com/media?url=https%3A%2F%2Fpreview.redd.it%2Fshow-me-your-statusline-v0-5r9nu6in6nyc1.png%3Fwidth%3D1922%26auto%3Dwebp%26s%3D0299ed5e1aa95b52ebb4c468b4a1a60a1d1127ae
[2]: https://www.reddit.com/media?url=https%3A%2F%2Fpreview.redd.it%2Fshow-me-your-statusline-v0-vmw6cl41snyc1.png%3Fwidth%3D1876%26auto%3Dwebp%26s%3D07ff31e7f74331dbe074d23d7dac2cf2cbe45da8
[3]: https://codecompanion.olimorris.dev/installation.html#mini-diff
[4]: https://codecompanion.olimorris.dev/configuration/chat-buffer.html#diff
[5]: https://github.com/neovim/neovim/issues/14409
[6]: https://github.com/folke/which-key.nvim/issues/967
[7]: https://imgur.com/a/UVdilYc
[8]: https://github.com/rezhaTanuharja/minimalistNVIM
[9]: https://github.com/idr4n/nvim-lua
[10]: https://github.com/strash/everybody-wants-that-line.nvim
[11]: https://github.com/OXY2DEV/bars.nvim/wiki/Guide_Statusline
[12]: https://github.com/NvChad/ui/blob/v2.0/lua/nvchad/statusline/default.lua
