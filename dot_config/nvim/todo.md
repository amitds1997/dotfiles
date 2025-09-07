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
- `which-key.nvim`
- `SchemaStore`
- `gitsigns`
- Use `mini.move` to move blocks up/down/left/right in visual selection mode
- Find out how to get files to remember custom folds done earlier
- Check what colorschemes work with transparent/not-transparent and mark it
- Replace `nvim-dap-ui` with `nvim-dap-view`
- Set up copilot
- Replace `gitsigns.nvim` with `mini.diff` and `mini.git`
- Completed statusline
  - Add `git` info (Can we do it [at the top][1] along with file name? Or maybe
    at the rightmost spot on statusline?)
  - Make all colors be determined by the mode kind of like [this][7]
  - Read through this guide on building a statusline: [Guide][11]
  - ~Better file name and path along with status. Except the file name, [dim the
    rest of the path][2]~
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

## Needs external work/help

- Replace `nvim-autopairs` with `blink.pairs`
- Hack added to [which-key](./lua/plugins/which-key.lua) until this is fixed:
  [which-key#issue][6]
- Fix the twitch in the completion menu where responses keep altering b/w
  different answers (needs reproduction) happens because of Copilot most likely
- Set up a nice "winbar" to show file name and current status
- Remove magical white spaces from markdown concealed when [this][5] is fixed
- Add shorter when statusline is very compressed (should wait for it to happen)

## Not needed yet

- [Mini-diff][3] with `CodeCompanion` (see also: [diff][4]). Adjust
  `Inline assistant` portion of the configuration.
- `mcphub.nvim` (Do we need `vectorcode`?)
- Integrate:
  - `:compiler` with `:make` for different filetypes
- Set up sessions in Neovim (`sessionoptions`, see LazyVim)
- Revisit installing `overseer` for `preLaunchTask` and `postDebugTask`

## Pending tasks

### Navigation & Selection

- Figure out way to jump LSP + Treesitter contexts better
- Jump to start and end of methods/functions
- Swap arguments/parameters
- Setup incremental selection via `nvim-treesitter`
- Plugins to add/setup:
  - `mini.ai`

### Plugins

- Consider replacing:
  - `which-key` with `mini.clue`
- Plugins to remove:
  - `lazydev.nvim`
  - `which-key.nvim`

### Statusline

- Evaluate [idr4n/nvim-lua][9], [this][8], [this][10], and [NvChad][12] for
  statusline organization

### Miscellaneous

- After implementing our own toggle, Copilot is not working
- Fix Copilot not starting correctly at all times
  - In a buffer where it's running, run `Copilot disable` followed by enable;
    still not showing up :(
- Visit [this][13] when all's done
- Enable `f-string` using `basedpyright` LSP
- Remove `nvim-ufo`. I don't think I like it
- Automatically load `.env` files (if present). See [this][14]
- Set up a keymap to comment and move to the next line
- Review these:
  - [Proudest one-liners][15]

[1]:
  https://www.reddit.com/media?url=https%3A%2F%2Fpreview.redd.it%2Fshow-me-your-statusline-v0-5r9nu6in6nyc1.png%3Fwidth%3D1922%26auto%3Dwebp%26s%3D0299ed5e1aa95b52ebb4c468b4a1a60a1d1127ae
[2]:
  https://www.reddit.com/media?url=https%3A%2F%2Fpreview.redd.it%2Fshow-me-your-statusline-v0-vmw6cl41snyc1.png%3Fwidth%3D1876%26auto%3Dwebp%26s%3D07ff31e7f74331dbe074d23d7dac2cf2cbe45da8
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
[13]:
  https://github.com/olimorris/codecompanion.nvim/discussions/categories/announcements
[14]:
  https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/load-env-vars.lua
[15]:
  https://www.reddit.com/r/neovim/comments/1k4efz8/share_your_proudest_config_oneliners/
