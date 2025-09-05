# Dotfiles To Do list

## Fresh new tools

- `lazydocker` - Handle everything docker
- `viddy` - Replacement for `watch`
- `duckdb` - Nifty SQL-based file processor
- `tldr` (using `tlrc`) - Find usage patterns of a command
- `tokei` - Get fast, accurate count of lines
- `doggo` - A nicer DNS search utility
- `hyperfine` - Benchmarking tool
- `rmlint` - Clean up duplicate files
- `yazi` - New terminal based file manager
- `euporie` - Terminal-based `jupyter` notebook
- `eza` - New-world `ls` alternative
- `pv` - Pipe viewer; view more stuff

## 📋 To do lists

### Looking out for 👀

1. TUI-based AI Chat app (`crush` came close, but was slow; takes a lot more
   time than what other assistants take :/)
2. Better docker TUI (`lazydocker` is okay-ish)

### Dropped (for now) 🫳

1. In `kitty`, set up top tab page using Python script to handle stuff nicely.
   See: [megalithic/dotfiles][4]
2. In `kitty`, set up [startup session][3]. I guess we want:
   a. One tab dedicated to `dotfiles`

### Blocked 🚫

1. Automatic theme setting on both [`delta`][1] and [`lazygit`][2] together
2. Look for more use cases before spending time on `ast-grep` and `yazi`

### Pending ⏰

- [ ] Setup `-` as a word breaker when moving in the `cmdline` of the terminal
- [ ] Add `chezmoi` command to automatically loop over all paths and add any missing
      files as and when needed
- [ ] Set up `ipython` configuration dots
- [ ] Setup `1pass` and `bitwarden` workflows
- [ ] Database tool
- [ ] Better history management. Check out `altuin`
- [ ] Find ways to use fingerprint and passkeys more
- [ ] Set up `nvim` such that it uses history to find the file location in case it does not exist in the current directory
- [ ] Set up sane defaults for `nano` for those 1 in a million chances
- [ ] Set up `grc`

### Under review 📗

1. Setup a clipboard manager (For now, using `raycast` in-built clipboard)
2. Setup `raycast`
3. Setup `lazydocker`

### Done ✅

- [x] Tested out `harlequin` — Did not like it, did not have enough features to
      spend more time there
- [x] Test `ghostty` terminal. Now using it
- [x] Setup a process to set a bunch of files/directories in an order to VLC (in
      future, maybe another app)

  ```bash
  fd -0 'S01E([1-9][0-9])|S01E09' -e mkv | xargs -0 open -a VLC
  ```

[1]: https://github.com/dandavison/delta/issues/1968
[2]: https://github.com/jesseduffield/lazygit/issues/4366
[3]: https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.startup_session
[4]: https://github.com/megalithic/dotfiles/blob/main/config/kitty/tab_bar.py
