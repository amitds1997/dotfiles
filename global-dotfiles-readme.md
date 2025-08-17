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

### Blocked

1. Automatic theme setting on both [`delta`][3] and [`lazygit`][4] together
2. `ast-grep` seems useful but did not find any use case (or workflow) for it

### Pending

1. Setup `yazi` and `lazydocker`
2. Add `chezmoi` command to automatically loop over all paths and add any missing
   files as and when needed
3. Setup `1pass` and `bitwarden` workflows
4. Test out `crush` vs `elia`, `harlequin`
5. In `kitty`, set up top tab page using Python script to handle stuff nicely.
   See: [megalithic/dotfiles][1]
6. In `kitty`, set up [startup session][2]
7. Test `ghostty` terminal
8. A database and AI Chat tool
9. better history management
10. Find ways to use fingerprint and passkeys more

### Under review

1. Setup a clipboard manager (For now, using `raycast` in-built clipboard)
2. Setup `raycast`

### Done

1. Setup a process to set a bunch of files/directories in an order to VLC (in
   future, maybe another app)

   ```bash
   fd -0 'S01E([1-9][0-9])|S01E09' -e mkv | xargs -0 open -a VLC
   ```

[1]: https://github.com/megalithic/dotfiles/blob/main/config/kitty/tab_bar.py
[2]: https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.startup_session
[3]: https://github.com/dandavison/delta/issues/1968
[4]: https://github.com/jesseduffield/lazygit/issues/4366
