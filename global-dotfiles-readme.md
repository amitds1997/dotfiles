# Global Dotfiles README

## Fresh new tools

- `lazydocker` - Handle everything docker
- `viddy` - Replacement for `watch`
- `duckdb` - Nifty SQL-based file processor
- `tldr` (`tlrc`) - Find usage patterns of a command
- `tokei` - Get fast, accurate count of lines
- `doggo` - A nicer DNS search utility
- `hyperfine` - Benchmarking tool
- `rmlint` - Clean up duplicate files
- `yazi` - New terminal based file manager
- `euporie` - Terminal-based `jupyter` notebook
- `eza` - New-world `ls` alternative
- `pv` - Pipe viewer; view more stuff

## ToDo list

### Looking out for

1. TUI-based AI Chat app (`crush` came close, but was slow :/)
2. Better docker TUI (`lazydocker` is okay-ish)

### Blocked

1. Automatic theme setting on both [`delta`][3] and [`lazygit`][4] together
2. Look for more use cases before spending time on `ast-grep` and `yazi`

### Pending

1. Setup `lazydocker`
1. Add `chezmoi` command to automatically loop over all paths and add any missing
   files as and when needed
1. Setup `1pass` and `bitwarden` workflows
1. In `kitty`, set up top tab page using Python script to handle stuff nicely.
   See: [megalithic/dotfiles][1]
1. In `kitty`, set up [startup session][2]. I guess we want:
   a. One tab dedicated to `dotfiles`
1. Test `ghostty` terminal
1. A database and AI Chat tool
1. better history management
1. Find ways to use fingerprint and passkeys more

### Under review

1. Setup a clipboard manager (For now, using `raycast` in-built clipboard)
2. Setup `raycast`

### Done

1. Test out `harlequin` — Did not like it, did not have enough features to spend
   more time there
2. Setup a process to set a bunch of files/directories in an order to VLC (in
   future, maybe another app)

   ```bash
   fd -0 'S01E([1-9][0-9])|S01E09' -e mkv | xargs -0 open -a VLC
   ```

[1]: https://github.com/megalithic/dotfiles/blob/main/config/kitty/tab_bar.py
[2]: https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.startup_session
[3]: https://github.com/dandavison/delta/issues/1968
[4]: https://github.com/jesseduffield/lazygit/issues/4366
