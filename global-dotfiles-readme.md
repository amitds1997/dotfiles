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

## ToDo list

### Pending

1. In `kitty`, set up top tab page using Python script to handle stuff nicely.
   See: [megalithic/dotfiles][1]
2. In `kitty`, set up [startup session][2]
3. Setup `k9s`, `yazi` and `lazydocker`
4. Add `chezmoi` command to automatically loop over all paths and add any missing
   files as and when needed
5. Setup `1pass` and `bitwarden` workflows
6. Setup a clipboard manager
7. Setup `raycast`

### Done

1. Setup a process to set a bunch of files/directories in an order to VLC (in
   future, maybe another app)

   ```bash
   fd -0 'S01E([1-9][0-9])|S01E09' -e mkv | xargs -0 open -a VLC
   ```

[1]: https://github.com/megalithic/dotfiles/blob/main/config/kitty/tab_bar.py
[2]: https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.startup_session
